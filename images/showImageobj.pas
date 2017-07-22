{$mode objfpc}{$h+}
program demo;
 
uses classes, sysutils,
     FPImage, FPCanvas, FPImgCanv,
     FPWritePNG, FPReadPNG;
 
var canvas : TFPcustomCanvas;
    image : TFPCustomImage;
    writer : TFPCustomImageWriter;
    reader : TFPCustomImageReader;
begin
  { 
    Create the image size, this can be any size. 
    The reader will rescale it to the correct size 
  }
  image := TFPMemoryImage.Create (256, 256);
  canvas := TFPImageCanvas.Create (image);
  writer := TFPWriterPNG.Create;
  reader := TFPReaderPNG.Create;
  
  { Load it, this might take a while }
  image.LoadFromFile ('ball.png', reader);

  { Draw a circle }
  canvas.Ellipse (10,10, 90,90);
  
  { Setup PNG Write Config }
  with writer as TFPWriterPNG do
  begin
    Grayscale := false;
    Indexed := false;
    WordSized := false;
    UseAlpha := true;
  end;
  
  { Save to file }
  image.SaveToFile ('DrawTest.png', writer);
  
  { Clean up! }
  Canvas.Free;
  image.Free;
  writer.Free;
end.
