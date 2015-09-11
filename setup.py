from distutils.core import setup, Extension
from Cython.Build import cythonize

ext = Extension("myclasswrapper", sources=["myclasswrapper.pyx", "myclass.cpp"],language="c++")

setup(name="myclasswrapper", ext_modules=cythonize(ext))
