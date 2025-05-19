import rioxarray # for the extension to load
import rasterio as rio
import sys


def clip_raster(input_raster, reference_raster, output_raster, target_size=2000):
    """
    Clip an input raster to the extent of a reference raster and resize to target dimensions.
    
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
    
    # Handle nodata values
    if xds.rio.nodata is not None:
        clipped = clipped.rio.write_nodata(xds.rio.nodata, encoded=False, inplace=True)
    
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
            'compress': 'LZW'
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
                    resampling=Resampling.nearest
                )
    
    # Remove the temporary file
    import os
    if os.path.exists(temp_file):
        os.remove(temp_file)
    
    # Verify the output dimensions
    with rio.open(output_raster) as out_ds:
        actual_width = out_ds.width
        actual_height = out_ds.height
    
    print(f"Clipped raster saved to {output_raster} with dimensions {actual_width}x{actual_height}")
    
    # Verify dimensions match target
    if actual_width != target_size or actual_height != target_size:
        print(f"Warning: Output dimensions ({actual_width}x{actual_height}) do not match target ({target_size}x{target_size})")

if __name__ == '__main__':
    
    clip_raster(sys.argv[1],
    sys.argv[2],
    sys.argv[3], 2000)