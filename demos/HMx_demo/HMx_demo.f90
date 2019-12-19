PROGRAM HMx_demo

   USE array_operations
   USE cosmology_functions
   USE HMx
   IMPLICIT NONE
   !CHARACTER(len=256) :: cosmo, halomodel
   INTEGER :: icosmo, ihm, idemo

   WRITE(*, *) ''
   WRITE(*, *) 'Choose demo'
   WRITE(*, *) '1 - Basic demo'
   WRITE(*, *) '2 - Winint diagnostics'
   WRITE(*, *) '3 - Winint speed'
   WRITE(*, *) '4 - Dewiggle test'
   READ(*, *) idemo
   WRITE(*, *)

   IF (idemo == 1) THEN
      CALL basic_demo()
   ELSE IF (idemo == 2) THEN
      CALL winint_diagnosis()
   ELSE IF (idemo == 3) THEN
      CALL winint_speed()
   ELSE IF(idemo == 4) THEN
      CALL dewiggle_test()
   ELSE
      STOP 'HMX_DEMO: Error, demo specified incorreclty'
   END IF

CONTAINS

   SUBROUTINE basic_demo()

      IMPLICIT NONE
      INTEGER :: icosmo, ihm
      TYPE(cosmology) :: cosm
      TYPE(halomod) :: hmod
      LOGICAL, PARAMETER :: verbose = .TRUE.
      REAL, PARAMETER :: a = 1.0

      ! Assigns the cosmological model
      icosmo = -1
      CALL assign_init_cosmology(icosmo, cosm, verbose)

      ! Initiliasation for the halomodel calcualtion
      ihm = -1
      CALL assign_init_halomod(ihm, a, hmod, cosm, verbose)

   END SUBROUTINE basic_demo

   SUBROUTINE winint_diagnosis()

      ! Stuff for diagnosing problems with the window function integrand
      IMPLICIT NONE
      INTEGER, PARAMETER :: irho = 11
      REAL, PARAMETER :: rv = 1.
      REAL, PARAMETER :: c = 4.
      REAL, PARAMETER :: rs = rv/c
      REAL, PARAMETER :: p1 = 1.18
      REAL, PARAMETER :: p2 = 0.
      REAL, PARAMETER :: rmin = 0.
      REAL, PARAMETER :: rmax = rv
      CHARACTER(len=256), PARAMETER :: outfile = 'data/integrand.dat'

      CALL winint_diagnostics(rmin, rmax, rv, rs, p1, p2, irho, outfile)

   END SUBROUTINE winint_diagnosis

   SUBROUTINE winint_speed()

      ! Speed tests for W(M,k) integrals
      USE array_operations
      IMPLICIT NONE
      REAL, ALLOCATABLE :: k(:)

      REAL, PARAMETER :: kmin = 1e-2
      REAL, PARAMETER :: kmax = 1e3
      INTEGER, PARAMETER :: nk = 512
      REAL, PARAMETER :: rv = 1.    ! Virial radius
      REAL, PARAMETER :: c = 4.     ! Concentration
      REAL, PARAMETER :: rs = rv/c
      REAL, PARAMETER :: p1 = 1.2   ! Gamma
      REAL, PARAMETER :: p2 = 0.
      INTEGER, PARAMETER :: irho = 11  ! KS density profile
      REAL, PARAMETER :: rmin = 0.
      REAL, PARAMETER :: rmax = rv
      CHARACTER(len=256), PARAMETER :: base = 'data/results_'
      CHARACTER(len=256), PARAMETER :: ext = '.dat'

      ! k range
      CALL fill_array(log(kmin), log(kmax), k, nk)
      k = exp(k)

      ! Halo parameters
      CALL winint_speed_tests(k, nk, rmin, rmax, rv, rs, p1, p2, irho, base, ext)

   END SUBROUTINE winint_speed

   SUBROUTINE dewiggle_test()

      IMPLICIT NONE
      REAL, ALLOCATABLE :: k(:)
      INTEGER :: i
      TYPE(cosmology) :: cosm
      TYPE(halomod) :: hmod

      REAL, PARAMETER :: a = 1.
      REAL, PARAMETER :: kmin = 1e-3
      REAL, PARAMETER :: kmax = 1e1
      INTEGER, PARAMETER :: nk = 1024
      LOGICAL, PARAMETER :: verbose = .TRUE.
      CHARACTER(len=256), PARAMETER :: outfile = 'data/dewiggle.dat'

      ! Assigns the cosmological model
      icosmo = 26 ! Boring with CAMB
      CALL assign_init_cosmology(icosmo, cosm, verbose)

      ! Initiliasation for the halomodel calcualtion
      ihm = 31 ! Dewiggle
      CALL assign_init_halomod(ihm, a, hmod, cosm, verbose)
      hmod%sigv = 1000. ! [Mpc/h] Fix very high so as to completey damp wiggles away

      ! Write results
      CALL fill_array(log(kmin), log(kmax), k, nk)
      k=exp(k)
      OPEN(7, file = outfile)
      DO i = 1, nk
         WRITE(7, *) k(i), p_lin(k(i), a, cosm), p_dewiggle(k(i), hmod, cosm)
      END DO
      CLOSE(7)

   END SUBROUTINE dewiggle_test

END PROGRAM HMx_demo