/**
 *@Brief:predict the case when man hit the tree
 *Author: Soyn
**/


import processing.serial.*;
import java.nio.ByteBuffer;

boolean drawTree = true;
int maxTreeSteps;
float branchAngle;
float treeLength;
color background;
float temp;
Serial myport;



float notMove = 4.80;


void setup()
{
  /**
  * read data from file.
  **/ 
  size(1024,768);
  myport = new Serial(this, Serial.list()[0], 9600);
  background = #050505;
  maxTreeSteps = 20;
  branchAngle = 30;
  treeLength = 50;
  temp = treeLength;
}

float[] data = new float[21];
float f;
int index = 0;

void draw()
{ 
  if(myport.available() > 0)
  {
    String inString = myport.readStringUntil((int)'\n');
    
    if(inString != null && inString.length() > 0){
      
      f = decodeFloat(inString.substring(0,10));
      println(f);
      if(f > 11.0 && treeLength < 200)
        treeLength += 10;
       else{
          if(treeLength >= 200){
            delay(2000);
            treeLength = 50;
            }
       }
    }
    
  noFill();
  background(background);   
  
  if (drawTree){
    translate(width / 2, height);
    tree(treeLength, treeLength * 0.4, 1);      
  }
   myport.clear();
}  
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


void Check(){
  treeLength -= 2;
}

///
/// <summary>the main body of drawing a tree</summary>
/// <para name = "treeLength"> the length of the tree</para name>
/// <para name = "strokeWeight"></para name>
/// <para name = "currentTreeStep">the step will run</para name>
///

void tree(float treeLength, float strokeWeight, int currentTreeStep) {
  
  //{*
  
    /*
    * <summary>to set the color of the branch and leaves</summary>
    */
  if (currentTreeStep < maxTreeSteps) {
    
    if(currentTreeStep >= 8 && currentTreeStep <=10)
      stroke(#558351); //set color light green
     else{
      if(currentTreeStep >10 && currentTreeStep <=20)
          stroke(#199B0E); //set hard green
        
      else{
      stroke(#311919);//set branch color
    }
     }
    
  //*}
    strokeCap(PROJECT);
    strokeWeight(strokeWeight);
    line(0, 0, 0, -treeLength);  
    translate(0, -treeLength);
    
    strokeWeight *= 0.5;
    treeLength *= 0.75;
    
    if (treeLength > 1) {
      pushMatrix();
      rotate(radians(branchAngle));
      tree(treeLength, strokeWeight, currentTreeStep + 1);
      popMatrix();
      
      pushMatrix();
      rotate(-radians(branchAngle));
      tree(treeLength, strokeWeight, currentTreeStep + 1);
      popMatrix();
    } 
  }
}
