Run Geant4 validation via Docker
=====================================================
Copyright (c) Andrea Dotti (SLAC National Accelerator Laboratory), 2016

This image contains the first application for G4 validation in a containerazied environment.
The current application is **ProcessTest** an application used to perform simulation of a single interaction.

This documentation serves as a brief overview of how to run the application container.

Geant4 docker images: https://hub.docker.com/r/andreadotti/geant4/ images created following instructions at:
https://github.com/andreadotti/docker-geant4

and application source-code: https://gitlab.cern.ch/adotti/ProcessTest (not a public repo yet).

Build the container image
--------------------------------

1. To build the image it is assumed you already have the binaries of the application following the instructions at:
     https://github.com/andreadotti/docker-geant4 .
2. Edit `Dockerfile.ProcessTest` if needed, in particular you will need to modify the Geant4 version 
     number in the `FROM` field.
3. Build the image: `docker build -f Dockerfile.ProcessTest -t <tag>`.

Get the container image
------------------------------
Get the container image via: `docker pull andreadotti/geant4-val:<tag>`.  The value of `<tag>` will tell you which version 
of Geant4 is used and other useful information. Test it with: `docker run --rm <imageID> ProcessTest --version` and ignore 
the errors about databases not found. The last line will tell you the version of the application being used.

**Geant4 Databases**: Databases are not included in the image, specify as a docker volume the location of the databases.

Labels
--------
In the following we make use of docker labels to store values of paths and others.  
The labels have the format: `org.geant4.processtest.<variable>`. To see all labels exported by the this image type:
`docker inspect --format='{{.Config.Labels}}' <inageID>`.  
Some useful variables:

 * `org.geant4.processtest.installation_dir` : Where code is installed
 * `org.geant4.processtest.macro_dirs` : List of directories where macros can be found
 * `org.geant4.processtest.readme ` : This file
 * `org.geant4.processtest.docs` :  List of additional documentation files/dirs
 * `org.geant4.processtest.output` : List of output files

In the following text `$org.geant4.processtest.<variable>` should be replaced with the value of the corresponding label.

Additional Documentation
------------------------
Additional documentation is included with the software: `docker run --rm <imageID> cat $org.geant4.processtest.docs[idx]`

Running ProcessTest
============

Cross-sections
--------------
Cross-sections script will produce json files containing total cross-section plot for selected
EM and HAD proceses.  
Cross-sections validation files can be found under `$org.geant4.processtest.cross_sections_dir`. Documentation is available
at: `$org.geant4.processtest.docs[1]`.  
The scripts being executed are: `$org.geant4.processtest.cross_sections_dir/doXS_{had|EM}.sh`.

To run cross-section validations:
```
docker run -v "<dbdir>:/usr/local/gent4/data:ro" -v "$PWD:/output:rw" <imageID> \
		/runme.xs.sh <options>
```
Where:
 
   * `<dbdir>` is the location, on the host of the Geant4 DB
   * `<imagename>` is the docker image name for the validation
   *   `<options>` specify the material list to run the validation, three  options are available:
	1. A single material name is specified as known to Geant4 NIST database (e.g. G4_Cd)
	2. A sub-set of the periodic table (up to G4_U included, e.g. 92 elements)
	can be specified passing two integers: `<group>` and `<numgr>` as in: 
	`docker run [...] runme.xs.sh 2 10` that means: divide the periodic table in
	10 groups and run the second group, e.g. elements from number 10 (G4_Ne)
	to number 18 (G4_Ar). Note: the last group contains all elements up to G4_U 
	included. So in the example groups 1 to 9 have each 9 elements and group 10
	calculates cross-sections for the remaining 11 elements.
	3. Passing nothing will run calculations on the entire periodic table
	
Ouput will be located in the docker instance `/output` directory, in the example shared 
with host's `$PWD`. The output consists of a tarball files: `crosssections*.tgz` 
**Note on timing**: Calculating cross-sections can take some time, as an example on my 
laptop a single element takes ~20 minutes and tarball dimension is ~2MB.

Single Interaction
------------------
Single interactions can be simulated using one of the `run.mac` macros the location of the macro defines
 the interaction property to be studied.
 For example to study compton scattering at 100 keV on carbon, run with the macro: 
 `${org.geant4.processtest.installation_dir}/${org.geant4.processtest.macro_dirs}/Compton/0.1MeV/G4_C/run.mac`.  
For interactive sessions, the application should be executed from:
`${org.geant4.processtest.installation_dirs}/${org.geant4.processtest.macro_dirs}/../`.   

Run the following command to see all available macros: `docker run --rm $instanceid find validation -name run.mac`.

To run a given configuration:
```
docker run -v "<dbdir>:/usr/local/geant4/data:ro" -v "$PWD:/output:rw" <imageID> \
		/runme.sh <physicslist> <macro>
```
Where:

   * `<dbdir>` is the location, on the host of the Geant4 DB
   * `<imagename>` is the docker image name for the validation
   * `<physicslist>` is the physics list name to be used (e.g. `FTFP_BERT`)
   * `<macro>` is the macro file to be executed (e.g. `validation/Compton/0.1MeV/G4_C/run.mac`)
   
Ouput will be located in the docker instance `/output` directory, in the example shared 
with host's `$PWD`. The output consists of a tarball file.
