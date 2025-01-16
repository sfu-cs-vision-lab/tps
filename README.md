# Thin-Plate Spline Illumination Estimation Automatic White Balancing Method

[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=sfu-cs-vision-lab/tps)

### Abstract
Thin-plate spline interpolation is used to interpolate the chromaticity of the color of the incident scene illumination across a training set of images. Given the image of a scene under unknown illumination, the chromaticity of the scene illumination can be found from the interpolated function. The resulting illumination-estimation method can be used to provide color constancy under changing illumination conditions and automatic white balancing for digital cameras. A thin-plate spline interpolates over a nonuniformly sampled input space, which in this case is a training set of image thumbnails and associated illumination chromaticities. To reduce the size of the training set, incremental k medians are applied. Tests on real images demonstrate that the thin-plate spline method can estimate the color of the incident illumination quite accurately, and the proposed training set pruning significantly decreases the computation.

### Citation

```
@article{Shi:11,
    author = {Lilong Shi and Weihua Xiong and Brian Funt},
    journal = {J. Opt. Soc. Am. A},
    keywords = {Digital image processing; Vision, color, and visual optics ; Color; Color, measurement ; Color vision; Camera calibration; Illumination; Image registration; Interpolation; Light sources; Neural networks},
    number = {5},
    pages = {940--948},
    publisher = {Optica Publishing Group},
    title = {Illumination estimation via thin-plate spline interpolation},
    volume = {28},
    month = {May},
    year = {2011},
    url = {https://opg.optica.org/josaa/abstract.cfm?URI=josaa-28-5-940},
    doi = {10.1364/JOSAA.28.000940},
    abstract = {Thin-plate spline interpolation is used to interpolate the chromaticity of the color of the incident scene illumination across a training set of images. Given the image of a scene under unknown illumination, the chromaticity of the scene illumination can be found from the interpolated function. The resulting illumination-estimation method can be used to provide color constancy under changing illumination conditions and automatic white balancing for digital cameras. A thin-plate spline interpolates over a nonuniformly sampled input space, which in this case is a training set of image thumbnails and associated illumination chromaticities. To reduce the size of the training set, incremental k medians are applied. Tests on real images demonstrate that the thin-plate spline method can estimate the color of the incident illumination quite accurately, and the proposed training set pruning significantly decreases the computation.},
}
```
