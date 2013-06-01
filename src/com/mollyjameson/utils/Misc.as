package com.mollyjameson.utils 
{
	/**
	 * ...
	 * @author Molly Jameson
	 */
	public class Misc 
	{
		public static function HexToRGB(value:uint):Object 
		{	
			var rgb:Object = new Object();
			rgb.r = ((value >> 16) & 0xFF)/255;
			rgb.g = ((value >> 8) & 0xFF)/255;
			rgb.b = (value & 0xFF)/255;
			return rgb;
		}
		
		public static function format(num:Number,precesion:Number = 2):String
		{
			return num.toFixed(precesion);
			//return commaCoder(num.toFixed(precesion));
		}
		private static function commaCoder(yourNum:String):String 
		{
			var numtoString:String = new String();
			var numLength:Number = yourNum.length;
			numtoString = "";
			for (var i:int = 0; i < numLength; i++) 
			{ 
				if ( yourNum.charAt(i) == "." )
				{
					break;
				}
				if ((numLength - i) % 3 == 0 && i != 0) 
				{
					numtoString += ",";
				}
				numtoString += yourNum.charAt(i);
				//trace(numtoString);
			}
			return numtoString;
		}
	}

}