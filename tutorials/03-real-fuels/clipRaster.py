import rioxarray # for the extension to load
import xarray
import rasterio as rio
import sys


def clip_raster(input_raster, reference_raster, output_raster):
    """
    input_raster : string to file location to clip
    reference_raster: string to file location of the reference raster
    output_raster : string to file location for the clipped output raster
    """
    xds = rioxarray.open_rasterio(input_raster)
    with rio.open(reference_raster) as dataset:
        xds.rio.clip_box(
            minx=dataset.bounds.left,
            miny=dataset.bounds.bottom,
            maxx=dataset.bounds.right,
            maxy=dataset.bounds.top,
            crs=dataset.crs,
        ).rio.to_raster(output_raster, driver="GTiff", compress="LZW")

if __name__ == '__main__':
    
    clip_raster(sys.argv[1],
    sys.argv[2],
    sys.argv[3])