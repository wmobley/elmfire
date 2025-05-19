import rioxarray # for the extension to load
import rasterio as rio
import sys
from rasterio.warp import calculate_default_transform, reproject, Resampling
import numpy as np


def clip_raster(input_raster, reference_raster, output_raster, target_size=2000, nodata_value=-9999):
    """
    Clip an input raster to the extent of a reference raster, resize to target dimensions,
    and convert nodata values to -9999 for ELMFIRE compatibility.
    
    Parameters:
    -----------
    input_raster : str
        Path to the input raster file to be clipped
    reference_raster: str
        Path to the reference raster file that defines the clip extent
    output_raster : str
        Path where the clipped output raster will be saved
    target_size : int
        Target size for both width and height of the output raster (default: 2000)
    nodata_value : int
        Value to use for nodata pixels in the output (default: -9999 for ELMFIRE)
    """
    # Open the reference raster to get its extent and CRS
    with rio.open(reference_raster) as ref_ds:
        ref_bounds = ref_ds.bounds
        ref_crs = ref_ds.crs
    
    # Open and clip the input raster
    xds = rioxarray.open_rasterio(input_raster)
    
    # Clip to the reference raster's bounds
    clipped = xds.rio.clip_box(
        minx=ref_bounds.left,
        miny=ref_bounds.bottom,
        maxx=ref_bounds.right,
        maxy=ref_bounds.top,
        crs=ref_crs
    )
    
    # Reproject to the reference CRS if needed
    if xds.rio.crs != ref_crs:
        clipped = clipped.rio.reproject(ref_crs)
    
    # Convert original nodata to the specified nodata value (-9999 by default)
    if xds.rio.nodata is not None:
        # First, identify the original nodata values
        mask = clipped.isnull().values
        # Then write the new nodata value
        clipped = clipped.rio.write_nodata(nodata_value, encoded=True, inplace=True)
        # Apply the mask with the new nodata value
        clipped_data = clipped.values
        clipped_data[:, mask[0]] = nodata_value
        clipped.values = clipped_data
    else:
        # If no nodata value is defined, still set it for ELMFIRE compatibility
        clipped = clipped.rio.write_nodata(nodata_value, encoded=True, inplace=True)
    
    # Calculate new resolution to achieve target size
    x_res = (ref_bounds.right - ref_bounds.left) / target_size
    y_res = (ref_bounds.top - ref_bounds.bottom) / target_size
    
    # Create a temporary file for the clipped raster
    temp_file = output_raster + ".temp.tif"
    clipped.rio.to_raster(temp_file, driver="GTiff", compress="LZW")
    
    # Resample to target size
    with rio.open(temp_file) as src:
        # Calculate the transform for the desired dimensions
        dst_transform, dst_width, dst_height = calculate_default_transform(
            src.crs, src.crs, target_size, target_size, 
            ref_bounds.left, ref_bounds.bottom, 
            ref_bounds.right, ref_bounds.top
        )
        
        # Create the output file with target dimensions
        dst_kwargs = src.meta.copy()
        dst_kwargs.update({
            'crs': ref_crs,
            'transform': dst_transform,
            'width': target_size,
            'height': target_size,
            'compress': 'LZW',
            'nodata': nodata_value  # Set the nodata value to -9999 for ELMFIRE
        })
        
        with rio.open(output_raster, 'w', **dst_kwargs) as dst:
            for i in range(1, src.count + 1):
                reproject(
                    source=rio.band(src, i),
                    destination=rio.band(dst, i),
                    src_transform=src.transform,
                    src_crs=src.crs,
                    dst_transform=dst_transform,
                    dst_crs=ref_crs,
                    resampling=Resampling.nearest,
                    nodata=nodata_value  # Ensure nodata is handled during reprojection
                )
    
    # Remove the temporary file
    import os
    if os.path.exists(temp_file):
        os.remove(temp_file)
    
    # Verify the output dimensions
    with rio.open(output_raster) as out_ds:
        actual_width = out_ds.width
        actual_height = out_ds.height
        actual_nodata = out_ds.nodata
    
    print(f"Clipped raster saved to {output_raster} with dimensions {actual_width}x{actual_height}")
    print(f"Nodata value set to {actual_nodata}")
    
    # Verify dimensions match target
    if actual_width != target_size or actual_height != target_size:
        print(f"Warning: Output dimensions ({actual_width}x{actual_height}) do not match target ({target_size}x{target_size})")

if __name__ == '__main__':
    if len(sys.argv) < 4:
        print("Usage: python clipRaster.py input_raster reference_raster output_raster [target_size]")
        sys.exit(1)
    
    target_size = 2000
    if len(sys.argv) > 4:
        target_size = int(sys.argv[4])
    
    clip_raster(sys.argv[1], sys.argv[2], sys.argv[3], target_size, nodata_value=-9999)