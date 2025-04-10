! *****************************************************************************
MODULE ELMFIRE_CALIBRATION
! *****************************************************************************

USE ELMFIRE_VARS

IMPLICIT NONE

CONTAINS 

! *****************************************************************************
SUBROUTINE READ_CALIBRATION_BY_PYROME
! *****************************************************************************

INTEGER :: I, IP, IOS, IFBFM(0:100), IERR, N
REAL :: READARR(1:400), PDFSUM
CHARACTER(400) :: FN
INTEGER, PARAMETER :: NUM_PYROMES = 128
INTEGER, PARAMETER :: NUM_FUEL_MODELS = 78

IF (ADJUSTMENT_FACTORS_BY_PYROME ) THEN
   ALLOCATE (ADJ_PYROME(1:NUM_PYROMES,0:303))
   ADJ_PYROME(:,:) = 1.
   IF (IRANK_WORLD .EQ. 0) THEN
      FN = TRIM(FUELS_AND_TOPOGRAPHY_DIRECTORY) // TRIM (ADJUSTMENT_FACTORS_FILENAME)
      OPEN(LUINPUT,FILE=TRIM(FN),FORM='FORMATTED',STATUS='OLD',IOSTAT=IOS)
      READ (LUINPUT,*,IOSTAT=IOS) (IFBFM(I), I = 0, NUM_FUEL_MODELS)
      DO IP = 1, NUM_PYROMES
         READ (LUINPUT,*) N, (READARR(I), I = 1, NUM_FUEL_MODELS)
         DO I = 1, NUM_FUEL_MODELS
            ADJ_PYROME(IP,IFBFM(I)) = READARR(I)
         ENDDO      
      ENDDO
      CLOSE(LUINPUT)
   ENDIF
   IF (NPROC .GT. 1) CALL MPI_BCAST(ADJ_PYROME, NUM_PYROMES*304, MPI_REAL, 0, MPI_COMM_WORLD, IERR)
ENDIF

IF (DURATION_PDF_BY_PYROME) THEN
   ALLOCATE (DURATION_PDF_PYROME(1:NUM_PYROMES,1:365))
   ALLOCATE (DURATION_CDF_PYROME(1:NUM_PYROMES,0:DURATION_MAX_DAYS))
   DURATION_PDF_PYROME(:,:) = 0.
   DURATION_CDF_PYROME(:,:) = 0.

   IF (IRANK_WORLD .EQ. 0) THEN
      FN = TRIM(FUELS_AND_TOPOGRAPHY_DIRECTORY) // TRIM (DURATION_PDF_FILENAME)
      OPEN(LUINPUT,FILE=TRIM(FN),FORM='FORMATTED',STATUS='OLD',IOSTAT=IOS)
      READ (LUINPUT,*,IOSTAT=IOS)
      DO IP = 1, NUM_PYROMES
         READ (LUINPUT,*) N, (READARR(I), I = 1, 365)
         DO I = 1, 365
            DURATION_PDF_PYROME(IP,I) = READARR(I)
         ENDDO      
      ENDDO
      CLOSE(LUINPUT)

      DURATION_PDF_PYROME(:,DURATION_MAX_DAYS+1:365) = 0.

      DO IP = 1, NUM_PYROMES
         PDFSUM = 0.
         DO I = 1, DURATION_MAX_DAYS
            PDFSUM = PDFSUM + DURATION_PDF_PYROME(IP,I)
         ENDDO
         IF (PDFSUM .GT. 1E-9) THEN
            DURATION_PDF_PYROME(IP,:) = DURATION_PDF_PYROME(IP,:) / PDFSUM
         ELSE
            DURATION_PDF_PYROME(IP,1:DURATION_MAX_DAYS) = 1.0 / REAL (DURATION_MAX_DAYS)
         ENDIF
         DO I = 1, DURATION_MAX_DAYS
            DURATION_CDF_PYROME(IP,I) = DURATION_CDF_PYROME(IP,I-1) + DURATION_PDF_PYROME(IP,I)
         ENDDO
      ENDDO
   ENDIF

   IF (NPROC .GT. 1) CALL MPI_BCAST(DURATION_CDF_PYROME, NUM_PYROMES*(DURATION_MAX_DAYS+1), MPI_REAL, 0, MPI_COMM_WORLD, IERR)
ENDIF

IF (CALIBRATION_CONSTANTS_BY_PYROME ) THEN
   ALLOCATE (INITIAL_ATTACK_TIME_PYROME         (1:NUM_PYROMES) )
   ALLOCATE (B_SDI_PYROME                       (1:NUM_PYROMES) )
   ALLOCATE (MAX_CONTAINMENT_PER_DAY_PYROME     (1:NUM_PYROMES) )
   ALLOCATE (AREA_NO_CONTAINMENT_CHANGE_PYROME  (1:NUM_PYROMES) )
   ALLOCATE (SIMULATION_DURATION_PYROME         (1:NUM_PYROMES) )
   ALLOCATE (IGNITION_DENSITY_ADJ_PYROME        (1:NUM_PYROMES) )

   IF (IRANK_WORLD .EQ. 0) THEN
      FN = TRIM(FUELS_AND_TOPOGRAPHY_DIRECTORY) // TRIM (CALIBRATION_CONSTANTS_FILENAME)
      OPEN(LUINPUT,FILE=TRIM(FN),FORM='FORMATTED',STATUS='OLD',IOSTAT=IOS)
      READ(LUINPUT,*,IOSTAT=IOS)
      DO IP = 1, NUM_PYROMES
         READ (LUINPUT,*,IOSTAT=IOS) N, (READARR(I), I = 1, 6)
         INITIAL_ATTACK_TIME_PYROME(IP)         = READARR(1)
         B_SDI_PYROME(IP)                       = READARR(2)
         MAX_CONTAINMENT_PER_DAY_PYROME(IP)     = READARR(3)
         AREA_NO_CONTAINMENT_CHANGE_PYROME(IP)  = READARR(4)
         SIMULATION_DURATION_PYROME(IP)         = READARR(5)
         IGNITION_DENSITY_ADJ_PYROME(IP)        = READARR(6)
      ENDDO
      CLOSE(LUINPUT)
   ENDIF
   IF (NPROC .GT. 1) THEN
      CALL MPI_BCAST ( INITIAL_ATTACK_TIME_PYROME         , NUM_PYROMES, MPI_REAL, 0, MPI_COMM_WORLD, IERR )
      CALL MPI_BCAST ( B_SDI_PYROME                       , NUM_PYROMES, MPI_REAL, 0, MPI_COMM_WORLD, IERR )
      CALL MPI_BCAST ( MAX_CONTAINMENT_PER_DAY_PYROME     , NUM_PYROMES, MPI_REAL, 0, MPI_COMM_WORLD, IERR )
      CALL MPI_BCAST ( AREA_NO_CONTAINMENT_CHANGE_PYROME  , NUM_PYROMES, MPI_REAL, 0, MPI_COMM_WORLD, IERR )
      CALL MPI_BCAST ( SIMULATION_DURATION_PYROME         , NUM_PYROMES, MPI_REAL, 0, MPI_COMM_WORLD, IERR )
      CALL MPI_BCAST ( IGNITION_DENSITY_ADJ_PYROME        , NUM_PYROMES, MPI_REAL, 0, MPI_COMM_WORLD, IERR )
   ENDIF
ENDIF

! *****************************************************************************
END SUBROUTINE READ_CALIBRATION_BY_PYROME
! *****************************************************************************
! *****************************************************************************
END MODULE ELMFIRE_CALIBRATION
! *****************************************************************************