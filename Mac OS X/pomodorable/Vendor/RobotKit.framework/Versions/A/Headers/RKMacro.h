//
// RKMacro.h
// RobotKit
//
// Created by Jon Carroll on 8/19/11.
// Copyright 2011 Orbotix Inc. All rights reserved.
//

#ifndef RKMacro_h
#define RKMacro_h

/*!
 * @brief RKMacro - class for generating macros on the fly
 *
 * Init a macro by passing in your flags byte then add your commands
 * Once you are done adding macro command you can get the macro bytes
 * and send them to the ball. All add command methods return a bool
 * indicating success or failure.
 */


class RKMacro
{
private:
    unsigned char* macro;
    int length;
    void appendByte(unsigned char byte);
    int getAvailableBytes();
public:
    /*!
     * Initializer to create a macro
     */
    RKMacro();
    ~RKMacro();
    
    /*!
     * Add calibrate command to the macro
     * @param heading reset heading, values between 0-359
     * @param delay delay in ms 0-255
     * @return success/failure in adding the command
     */
    bool calibrate(int heading, int delay);
    
    /*!
     * Add RGB LED color change command
     * @param r red intensity, values between 0.0-1.0
     * @param g green intensity, values between 0.0-1.0
     * @param b blue intensity, values between 0.0-1.0
     * @param delay delay for command in ms, values between 0-255
     * @return success/failure in adding the command
     */
    bool rgb(float r, float g, float b, int delay);
    
    /*!
     * Set the front LED to a given brightness.
     * @param brightness A value form 0.0 to 1.0 
     * @param delay The delay for the command in ms, values between 0-255.
     * @return success/failure in adding the command
     */
    bool frontLED(float brightness, int delay);

    /*!
     * Add Roll command to the macro
     * @param speed speed intensity, values between 0.0-1.0
     * @param heading heading, values between 0-359
     * @param delay delay in ms, values between 0-255
     * @return success/failure in adding the command
     */
    bool roll(float speed, int heading, int delay);
    
    /*!
     * Set the system delay 1 (applies to roll commands without delay)
     * @param delay delay in ms 0-65535
     * @return success/failure in adding the command
     */
    bool setSD1(int delay);
    
    /*!
     * Roll command that uses SD1
     * @param speed speed intensity, values between 0.0-1.0
     * @param heading heading, values between 0-359
     * @return success/failure in adding the command
     */
    bool rollSD1(float speed, int heading);
    
    /*!
     *  Set the system delay for color changes without a delay param
     *  @param system delay 
     *  @return true if successfully added to the macro
     */
    bool setSD2(int delay);
    
    /*!
     *  Send a color change command using SD2 as the delay
     *  @param color intensities from 0.0-1.0
     *  @return true if successfully added to the macro
     */
    bool rgbSD2(float r, float g, float b);
    
    /*!
     *  Turn on/off stabilization
     *  @param The stabilization setting
     *  @return true if successfully added to the macro
     */
    bool stabilization(uint8_t setting, int delay);
    
    /*!
     *  Add a raw delay command to the macro, this is two bytes so it can be longer
     *  @param the delay in ms, 0-65535
     *  @return true if the command was successfully added to the macro
     */
    bool delay(int delay);
    
    /*!
     *  Set the system speed 1 for use in rollSD1SPDx commands
     *  @param The speed, values between 0.0-1.0
     *  @return true if the command was successfully added to the macro
     */
    bool setSPD1(float speed);
    
    /*!
     *  Set the system speed 2 for use in rollSD1SPDx commands
     *  @param The speed, values between 0.0-1.0
     *  @return true if the command was successfully added to the macro
     */
    bool setSPD2(float speed);
    
    /*!
     *  Shorter 3 byte roll command using SD1 for delay and SPD1 for speed
     *  @param Heading, values between 0-359
     *  @return true if the command was successfully added to the macro
     */
    bool rollSD1SPD1(int heading);
    
    /*!
     *  Shorter 3 byte roll command using SD1 for delay and SPD2 for speed
     *  @param Heading, values between 0-359
     *  @return true if the command was successfully added to the macro
     */
    bool rollSD1SPD2(int heading);
    
    /*!
     * Turns on the motors in the mode and with the power provided. This command will turn
     * off stabilization, so use the stabilization method to turn.
     * @param leftMode The mode to run the motor, forward = 1 and backward = 2.
     * @param leftPower The power to run the motor at which is  a value from 0 to 255.
     * @param rightMode The mode to run the motor, forward = 1 and backward = 2.
     * @param rightPower The power to run the motor at which is  a value from 0 to 255.
     */
    bool rawMotor(uint8_t leftMode, uint8_t leftPower, uint8_t rightMode, uint8_t rightPower, int delay);
    
    /*!
     *  Put the ball to sleep, will wakeup after delay or shake (0 delay to sleep indefinately)
     *  @param delay, 0-65535 NOTE: This delay is in seconds unlike other macro command delays
     *  @return true if the command was successfully added to the macro
     */
    bool sleepnow(int delay);
    
    /*!
     *  Set the rotation rate for the ball
     *  @param rate, 0.0-1.0
     *  @return true if the command was successfully added to the macro
     */
    bool rotationRate(float rate);
    
    /*!
     *  Slew to the color over given delay
     *  @param red
     *  @param green
     *  @param blue
     *  @param delay 0-65535 time in ms to slew to the new color from current color
     */
    bool slew(float red, float green, float blue, int delay);
        
    /*!
     * Adds a macro command to emit an asynchronous message. 
     * @see RKMacroEmitMarker.
     * @param A number for the marker that is greater than 0.
     * @return true if the command was successfully added to the macro.
     */
    bool emitMarker(unsigned char number);
    
    /*!
     *  Makes the ball rotate the given number of degrees over time
     *  @param rotation - degrees to rotate, signed (-32,000 to 32,000)
     *  @param duration - the amount of time to take rotating to the given heading
     *  @return true if the command was successfully added to the macro
     */
    bool rotateOverTime(short rotation, int duration);
    
    /*!
     * Returns the current length (num bytes) in the macro
     * This does not include the header or flags bytes which are
     * appended before being sent to the ball.
     * @return number of bytes that will be returned by macroBytes()
     */
    int macroLength();
    
    /*!
     * Returns the bytes for this macro array.
     * Use macroLength() method to determine length
     * @return byte array for current macro
     */
    unsigned char* macroBytes();
    
};



#endif