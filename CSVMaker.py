# Creates a Dataframe with gene names, chromosome letters, and transcription levels using the Nagalakshmi data
# Then also adds GC content, Purine content, and gene length for just the genes in the transcript data using the yeast gene folder
# Finally prints the dataframe to a CSV file for use with the included R script

import pandas as pd
import os
import os.path
from os import path
import fileinput
import re

def main():

    
    geneNameList = []
    gcCounts = []
    purCounts = []
    lengths = []
    chroms = []

    for filename in os.listdir("YeastGenes"):
        # Assigns the gene file minus the header line to temp
        temp = ""
        my_path = path.join("YeastGenes", filename)
        firstLine = True
        for line in fileinput.input(files = (my_path)):
            if firstLine != True:
                temp += line
            firstLine = False
        # Get the geneName, length, and chromosome and calls functions to get GC and Pur content, then appends all these to lists
        geneName = filename[:-4]
        geneNameList.append(geneName)
        gcCounts.append(getGC(temp))
        purCounts.append(getPurines(temp))
        lengths.append(len(temp))
        chroms.append(filename[1])
        
        # Creates the main dataframe and adds the lists that were just filled out
    outputDF = pd.DataFrame()

    outputDF = outputDF.assign(GeneName=geneNameList)
    outputDF = outputDF.assign(GCcontent=gcCounts)
    outputDF = outputDF.assign(Purinecontent=purCounts)
    outputDF = outputDF.assign(Length=lengths)
    outputDF = outputDF.assign(Chromosome=chroms)
    
    # Goes through the transcription data to take out the transcription level and 
    # add it to the dataframe at the correct location based on gene name
    outputDF["TransLevels"] = -1.0
    lineNumber = 0
    for line in fileinput.input(files = ("Nagalakshmi_2008_3UTRs_V64.gff3")):
        lineNumber = lineNumber + 1
        if (lineNumber > 42 and  line[0] == 'c' and not line[3] == 'm'):
            workingWith = line
            pattern = r'ID=(.{7})'
            match = re.search(pattern, workingWith)
            transGeneName = match.group(1)

            #print(transGeneName)

            transLevel = workingWith[110:]
            transLevel = transLevel.strip()
            pattern = r'^[^=]*='
            transLevel = re.sub(pattern, '', transLevel)
            if (transLevel != "NA"):
                transLevel = float(transLevel)

            #print(transLevel)

            insertLocation = outputDF.loc[outputDF['GeneName'] == transGeneName]
            insertLocation = insertLocation.first_valid_index()

            #print(insertLocation)

            if(not type(insertLocation)==type(None) and not isinstance(transLevel, str)):
                outputDF.at[insertLocation, 'TransLevels'] = transLevel




        # Prints first few lines of dataframe and exports it to csv    
    
    print (outputDF.head())
    outputDF.to_csv("OrganizedData.csv", encoding='utf-8', index=False)



# Returns the GC fraction in given sequence
def getGC(seq):
    atCount = 0
    gcCount = 0
    for i in range(len(seq)):
        if seq[i] == "A" or seq[i] == "T":
            atCount = atCount + 1
        elif seq[i] == "G" or seq[i] == "C":
            gcCount = gcCount + 1
    ratio = gcCount / (gcCount + atCount)

    return ratio

# Returns the AG/purine fraction in given sequence
def getPurines(seq):
    purCount = 0
    pyrCount = 0
    for i in range(len(seq)):
        if seq[i] == "A" or seq[i] == "G":
            purCount = purCount + 1
        elif seq[i] == "T" or seq[i] == "C":
            pyrCount = pyrCount + 1
    ratio = purCount / (purCount + pyrCount)

    return ratio



if __name__ == "__main__":
    main()  
    #End program
    print ("\nCSV created")
    exit