/**
 *@Brief:predict the case when man hit the tree
 *Author: Soyn
**/


import processing.serial.*;
import java.nio.ByteBuffer;

Serial myport;



float[] notMove;


void setup()
{
  /**
  * read data from file.
  **/ 
  notMove = String2Float("NotMove.txt", notMove);
  myport = new Serial(this, Serial.list()[0], 9600);
  
}

float[] data = new float[51];
float f;
int index = 0;
void draw()
{

  float num;
  
  if(myport.available() > 0)
  {
    String inString = myport.readStringUntil((int)'\n');
    if(inString != null && inString.length() > 0)
    {
      f = decodeFloat(inString.substring(0,10));
      if((index % 51) < 50 )
        data[(index++ % 50)] = f;
      else{
        ++index;
        Todo(data);
      }
      
    }
  }
   myport.clear();
}  

float decodeFloat(String inString)
{
  byte [] inData = new byte[4];
  
  inString = inString.substring(2,10); //discard the leading "f"
  inData[0] = (byte) unhex(inString.substring(0,2));
  inData[1] = (byte) unhex(inString.substring(2,4));
  inData[2] = (byte) unhex(inString.substring(4,6));
  inData[3] = (byte) unhex(inString.substring(6,8));
  
  int intbits = (inData[3] << 24)|((inData[2] & 0xff) << 16) | ((inData[1] & 0xff) << 8)|(inData[0]&0xff);
  return Float.intBitsToFloat(intbits);
}

///<summary>Convert the String[] to float[]</summary>
///<para name = "fileName"> the file's name we are loading</para name>

float[] String2Float(String fileName, float[] dest)
{
  String[] lines = loadStrings(fileName);
  dest = float(lines);
  return dest;
}

///<summary> Decide the case we will enter</summary>
///<para name = "input">the input data from Aduino</para name>

void Todo(float[] input)
{
  float sum = 0,  avg;
  
  int len = getTheMinLen();
  if(len > 50)
    len = 50;
   
  for(int i = 0; i < len; ++i)
    sum += abs(input[i] - notMove[i]);
  avg = sum / len;
 
  
  if(avg >= 0 && avg <= 1)
  {
    println("Not move");
    println(avg);  
  }
  
  if(1 <avg && avg < 2.5)
  {
    println("Light");
    println(avg);
  }
  
  if(2.5 < avg && avg < 4.4)
  {
    println("Middle");
    println(avg);
  }
}


int getTheMinLen()
{
 int Min = notMove.length;
  return Min;
}

