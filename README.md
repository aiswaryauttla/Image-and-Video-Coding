# Image-and-Video-Coding

JPEG algorithm is implemented to compress the video. The task of a video codec is to reduce the amount of data when transmitting a video. We deal with redundancy reduction which exploits repetitions or correlations within a signal. In particular we focus on Huffman coding. We further decrease the rate by introducing lossy compression (Quantization) which excludes unnecessary information from the signal. First a frame is coded without temporal prediction (I-frame) and further frames are predicted from the most recently decoded frame (P-frame). The evaluation metric used is the Rate-Distortion plot.

![image](https://user-images.githubusercontent.com/80693116/177886716-a57c68d2-fb92-4a54-beec-3e96e36a39e2.png)

# References

G. Sullivan, editor. ITU-T Recommendation H.263: Transmission of Non- Telephone
Signals; Video Coding for Low Bit Rate Communication. ITU-T SG16, Jan. 1998.

A. Murat Tekalp. Digital video processing. Prentice-Hall, Inc., University of Michigan,
1995.

Y. Wang, Y.-Q. Zhang, and J. Ostermann. Video Processing and Communications.
Prentice Hall PTR, Upper Saddle River, NJ, USA, 2001.
