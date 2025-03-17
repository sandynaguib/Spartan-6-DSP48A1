# Spartan-6-DSP48A1
The Spartan-6 family offers a high ratio of DSP48A1 slices to logic, making it ideal for math intensive applications. DSP48A1 slice contains an 18-bit input pre-adder followed by an 18 x 18 bit two’s complement multiplier and a 48-bit sign-extended adder or subtracter or accumulator.  

The design of the code is divided into 4 stages as shown in the screenshot attached below, where I separated the generate statements to improve the readability of the code. The code is built using mainly generate if and two instantiated modules whether to load synchronously or asynchronously where the mux is implemented internally in the instantiated modules. 

![image](https://github.com/user-attachments/assets/c3e44b22-d6d3-4c38-b692-d336e4a600fa)


