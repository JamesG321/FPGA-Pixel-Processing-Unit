# Project Title

FPGA-Pixel-Processing-Unit

The Pixel Processing Unit (PPU) was originally a microprocessor in the Nintendo Entertainment
System that generates video signals from graphic data stored in memory (game cartridges). It
was quite advanced at its time, being able to support multiple sprites, moving backgrounds with
relatively low memory usage. This project aims to replicate the functions of the PPU using an
FPGA board: reading/displaying sprites stored in memory, supporting a background and having
simple motion and physics. All of the functions are rendered via hardware/logic within the FPGA
board.

## Getting Started

This project is built on the Altera De1-SoC-MLT2 Board. Download the .sv files and compile them on Quartus II, the Altera IDE
to run the program properly.

### Prerequisites

Proper installation of Quartus II/[Quartus Prime](https://www.altera.com/downloads/download-center.html)

[Altera De1-SoC-MLT2 Board](https://www.altera.com/content/dam/altera-www/global/en_US/portal/dsn/42/doc-us-dsnbk-42-4207350307415-de1-soc-mtl2-user-manual.pdf)


## Built With

* [Quartus Prime](https://www.altera.com/downloads/download-center.html)

## Documentation

See [PPU_Documentation](https://github.com/JamesG321/FPGA-Pixel-Processing-Unit/blob/master/PPU%20Documentation.pdf) for detailed explanation of overall architecture and detailed explanation of individual modules.

## Authors

* **James Guo** - [GitHub](https://github.com/JamesG321)
