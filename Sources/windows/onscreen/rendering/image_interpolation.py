from enum import Enum
from PyQt6.QtCore import Qt
from di.di import Dependencies
from qtutils.screens import Screens

from yage.utils.geometry import Size


class ImageInterpolationMode(Enum):
    NONE = 'none'
    DEFAULT = 'default'


class ImageInterpolationUseCase:
    def interpolation_mode(self, image_size: Size, rendering_size: Size) -> ImageInterpolationMode:
        raise NotImplementedError()

    def transformation_mode(self, mode: ImageInterpolationMode) -> Qt.TransformationMode:
        if mode == ImageInterpolationMode.NONE:
            return Qt.TransformationMode.FastTransformation
        return Qt.TransformationMode.SmoothTransformation


class ImageInterpolationUseCaseImpl(ImageInterpolationUseCase):
    def __init__(self):
        super().__init__()
        self.scale = Dependencies.instance(Screens).main.scale_factor

    def interpolation_mode(self, image_size: Size, rendering_size: Size) -> ImageInterpolationMode:
        pixel_count = self.scale * rendering_size.height
        image_height = image_size.height()
        if pixel_count % image_height == 0:
            return ImageInterpolationMode.NONE
        if pixel_count >= 1.5 * image_height:
            return ImageInterpolationMode.NONE
        return ImageInterpolationMode.DEFAULT
