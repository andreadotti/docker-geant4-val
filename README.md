My stuff to run Geant4 validation on Azure via Docker
=====================================================

Dockerfile.template is the docker file that I modified
to include azure-cli on top of applications. The correct
version of G4 FROM image needs to be setup.

Running Validation: ProcessTest
===============================

Cross-sections
--------------
Cross-sections script will produce json files containing total cross-section plot for selected
EM and HAD proceses.  
See *ProcessTest/validation/crosssections/doXS_{had|EM}.sh* for details.  
To run cross-sections plot production:
```
docker run -v "<dbdir>:/usr/local/gent4/data:ro" -v "$PWD:/output:rw" -t <imagename> runme.xs.sh <options>
```
Where: 
 * *<dbdir>* is the location, on the host of the Geant4 DB
 * *<imagename>* is the docker image name for the validation
 * *<options>* specify the material list to run the validation, in particular three 
   options are possible:
     1. A single material name is specified as known to Geant4 from the NIST 
        database (e.g. G4_Cd)
     2. A sub-set of the periodic table (up to G4_U included, e.g. 92 elements) 
        can be specified passing two integers: <group> and <numgr> as in: 
        ``docker run [...] runme.xs.sh 2 10`` that means: divide the period table in 
        10 groups and run the second group, e.g. elements from number 10 (G4_Ne) 
         to number 18 (G4_Ar). Note: the last group contains all elements up to G4_U 
         included. So in the example groups 1 to 9 have each 9 elements and group 10 
         calculates cross-sections for the remaining 11 elements. 
      3. Passing nothing will run calculations on the entire periodic table
Ouput will be located in the docker instance */output* directory, in the example shared 
with host's *$PWD* directory. The output consists of a tarball file: crosssections*.tgz 
**Note on timing**: Calculating cross-sections can take some time, as an example on my 
laptop a single element takes ~20 minutes.
