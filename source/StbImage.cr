lib StbImage
  fun flipVertically = stbi_flip_vertically_on_write(flip : LibC::Int) : Void
  fun writePNG = stbi_write_png(filename : LibC::Char*, width : LibC::Int, height : LibC::Int, channels : LibC::Int, data : Void*, stride : LibC::Int) : LibC::Int
  fun readPNG  = stbi_load(filename : LibC::Char*, width : LibC::Int*, height : LibC::Int*, channels : LibC::Int*, ignore : LibC::Int) : UInt32*
  fun freePNG  = stbi_image_free(UInt32*) : Void
end
