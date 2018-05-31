MODULE camb_stuff

  IMPLICIT NONE

CONTAINS

  SUBROUTINE read_CAMB_Pk(k,p,n,infile)

    USE file_info
    USE constants
    IMPLICIT NONE
    CHARACTER(len=*), INTENT(IN) :: infile
    REAL, ALLOCATABLE, INTENT(OUT) :: k(:), p(:)
    INTEGER, INTENT(OUT) :: n
    INTEGER :: i
    
    n=file_length(infile)
    n=n-1
    WRITE(*,*) 'READ_CAMB_PK: CAMB file: ', TRIM(infile)
    WRITE(*,*) 'READ_CAMB_PK: Number of points:', n
    WRITE(*,*)

    ALLOCATE(k(n),p(n))

    OPEN(7,file=infile)
    DO i=0,n
       IF(i==0) THEN
          READ(7,*)
       ELSE
          READ(7,*) k(i), p(i)
       END IF
    END DO
    CLOSE(7)

    p=4.*pi*p*(k**3)/(2.*pi)**3

  END SUBROUTINE read_CAMB_Pk

!!$  REAL FUNCTION plin_CAMB(k,k_tab,Pk_tab,nk)
!!$
!!$    USE interpolate
!!$    IMPLICIT NONE
!!$    REAL, INTENT(IN) :: k, k_tab(nk), Pk_tab(nk)
!!$    INTEGER, INTENT(IN) :: nk
!!$
!!$    plin_CAMB=find(log(k),log(k_tab),log(Pk_tab),nk,3,3,2)
!!$    
!!$  END FUNCTION plin_CAMB
  
END MODULE camb_stuff
