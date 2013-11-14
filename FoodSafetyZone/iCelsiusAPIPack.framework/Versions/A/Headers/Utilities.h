//
//  Utilities.h
//  iCelsius3
//
//  Created by Aginova on 1/7/11.
//  Copyright 2011 Aginova Sàrl. All rights reserved.
//

float getOptionalConvert(int unit,float value);
unsigned short CRC16(unsigned char *buf, int BufferLengthInBytes);
float SHT2x_CalcRH(unsigned short u16sRH);
float SHT2x_CalcTemperatureC(unsigned short u16sT);
