package com.vo
{
  import flash.utils.ByteArray;
  import flash.display.Sprite;
  
  public class Clone extends Sprite
  {
   private var cloneArray:ByteArray;
  
   public function Clone()
   {
    //Constructor
   }
  
   public function doClone(source:Object):*
   {
    cloneArray=new ByteArray();
    cloneArray.writeObject(source);
    cloneArray.position = 0;
    return (cloneArray.readObject());
   }
  }
} 