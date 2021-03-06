#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <vector>
#include <unordered_map>
#include <exception>

// Instruction format 16 bit
// NAME rd rs1 rs2
// LI rd literal
// OUT rs
// IN dr

std::unordered_map<std::string, uint16_t> opcodeDictionary = { { "ADD", 2 },
{ "SUB", 3 },
{ "AND", 4 },
{ "OR", 5 },
{ "XOR", 6 },
{ "SL", 7 },
{ "SR", 8 },
{ "SA", 9},
{ "BG", 10 },
{ "BL", 11 },
{ "BE", 12 } };

uint16_t TranslateLine(const std::string& line)
{
	uint16_t instructionBinary = 0;
	std::istringstream iss(line);
	std::string instructionName;
	iss >> instructionName;

	if (instructionName == "LI")
	{
		uint16_t opcode, rd, offset;
		opcode = 0;
		iss >> rd >> offset;
		if (rd > 15)
			throw std::runtime_error("Destination register must be between 0 and 15");
		if (offset > 255)
			throw std::runtime_error("Offset value must be between 0 and 255");

		instructionBinary = (rd << 8) | offset;
	}
	else if (instructionName == "IN" || instructionName == "OUT")
	{
		uint16_t opcode, rd, operation;
		opcode = 1;

		if (instructionName == "IN")
			operation = 1;
		else
			operation = 0;
		iss >> rd;
		if (rd > 15)
			throw std::runtime_error("Destination register must be between 0 and 15");
		instructionBinary = (opcode << 12) | (rd << 8) | operation;
	}
	else
	{
		uint16_t opcode, rd, rs1, rs2;
		opcode = opcodeDictionary.at(instructionName);
		iss >> rd >> rs1 >> rs2;
		if (rd > 15)
			throw std::runtime_error("Destination register must be between 0 and 15");
		if (rs1 > 15)
			throw std::runtime_error("Source 1 register must be between 0 and 15");
		if (rs2 > 15)
			throw std::runtime_error("Source 2 register must be between 0 and 15");

		instructionBinary = (opcode << 12) | (rd << 8) | (rs1 << 4) | rs2;
	}
	return instructionBinary;
}

int main(int argc, char * argv[])
{
	// First command line argument is the file path
	if (argc != 2)
		return EXIT_FAILURE;

	const std::string filePath = argv[1];
	//const std::string filePath = "Test.s";
	std::ifstream assemblyFile(filePath);

	std::vector<int16_t> outputVector;
	
	// Read and parse assembly file
	std::string line;
	int lineNumber = 1;
	try
	{
		while (std::getline(assemblyFile, line))
		{
			// If the line is not empty or a comment
			if (!(line.length() == 0 || line.at(0) == '#'))
				outputVector.emplace_back(TranslateLine(line));
			lineNumber++;
		}
	}
	catch (const std::runtime_error & error)
	{
		std::cerr << "Error while parsing the assembly file on line " << lineNumber << ": " << error.what() << std::endl;
	}
	catch (const std::out_of_range & error)
	{
		std::cerr << "Error while parsing the assembly file on line " << lineNumber << ": Unkonwn opcode" << std::endl;
	}
	assemblyFile.close();

	std::stringstream outputStream;
	outputStream << "-- ROM Initialization file\nWIDTH = 16;\nDEPTH = 512;\nADDRESS_RADIX = HEX;\nDATA_RADIX = HEX;\nCONTENT\nBEGIN" << std::endl;
	for (size_t i = 0; i < outputVector.size(); i++)
	{
		outputStream << "   " << std::hex << i << " : " << std::hex << outputVector[i] << ";" << std::endl;
	}
	outputStream << "END";

	// Write output binary file
	std::ofstream binaryFile(filePath + ".mif");
	binaryFile << outputStream.rdbuf();
	binaryFile.close();

	std::cout << "Done writing to binary file" << std::endl << std::endl;

	return EXIT_SUCCESS;
}
