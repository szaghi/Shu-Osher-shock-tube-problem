!< Test FOODIE with the integration of Euler 1D PDEs system.
program integrate_euler_1D
!-----------------------------------------------------------------------------------------------------------------------------------
!< Test FOODIE with the integration of Euler 1D PDEs system.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
use IR_Precision, only : R_P, I_P, FR_P, str
use type_euler_1D, only : euler_1D
use Data_Type_Command_Line_Interface, only : Type_Command_Line_Interface
use foodie, only : ls_runge_kutta_integrator
use pyplot_module, only :  pyplot
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(ls_runge_kutta_integrator) :: rk_integrator         !< Runge-Kutta integrator.
integer, parameter              :: rk_stages=7           !< Runge-Kutta stages number.
type(euler_1D)                  :: rk_stage(1:rk_stages) !< Runge-Kutta stages.
real(R_P)                       :: Dt                    !< Time step.
real(R_P)                       :: t                     !< Time.
real(R_P)                       :: t_final               !< Final time.
type(euler_1D)                  :: domain                !< Domain of Euler equations.
integer(I_P)                    :: order                 !< Order of accuracy.
real(R_P),    parameter         :: CFL=0.7_R_P           !< CFL value.
integer(I_P), parameter         :: Ns=1                  !< Number of differnt initial gas species.
integer(I_P), parameter         :: Nc=Ns+2               !< Number of conservative variables.
integer(I_P), parameter         :: Np=Ns+4               !< Number of primitive variables.
integer(I_P)                    :: Ni                    !< Number of grid cells.
real(R_P), allocatable          :: x(:)                  !< Cell center x-abscissa values.
logical                         :: plots                 !< Flag for activating plots saving.
logical                         :: results               !< Flag for activating results saving.
logical                         :: time_serie            !< Flag for activating time serie-results saving.
logical                         :: verbose               !< Flag for activating more verbose output.
integer(I_P)                    :: steps                 !< Time steps counter.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
call command_line_interface
call init
steps = 1
do while(t<t_final)
  if (verbose) print "(A)", ' Time step: '//str(n=dt)//', Time: '//str(n=t)
  Dt = domain%dt(Nmax=0_I_P, Tmax=t_final, t=t, CFL=CFL)
  call rk_integrator%integrate(U=domain, stage=rk_stage, dt=dt, t=t)
  t = t + dt
  steps = steps + 1
  call save_time_serie(t=t)
enddo
if (verbose) print "(A)", ' Time step: '//str(n=dt)//', Time: '//str(n=t)
call finish
stop
!-----------------------------------------------------------------------------------------------------------------------------------
contains
  subroutine command_line_interface()
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Handle Command Line Interface.
  !---------------------------------------------------------------------------------------------------------------------------------
  type(Type_Command_Line_Interface) :: cli   !< Command line interface handler.
  integer(I_P)                      :: error !< Error handler.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  ! setting Command Line Interface
  call cli%init(progname    = 'euler-1D',                                              &
                authors     = 'Fortran-FOSS-Programmers',                              &
                license     = 'GNU GPLv3',                                             &
                description = 'Test FOODIE library on 1D Euler equations integration', &
                examples    = ["euler-1D --results  ",                                 &
                               "euler-1D -r -t -v -p",                                 &
                               "euler-1D            ",                                 &
                               "euler-1D --plots -r "])
  call cli%add(switch='--Ni', help='Number finite volumes used', required=.false., act='store', def='100', error=error)
  call cli%add(switch='--order', help='Order of accuracy', choices='1,3,5,7', required=.false., act='store', def='1', error=error)
  call cli%add(switch='--t_final', help='Final time of integration', required=.false., act='store', def='0.178d0', error=error)
  call cli%add(switch='--results', switch_ab='-r', help='Save results', required=.false., act='store_true', def='.false.', &
               error=error)
  call cli%add(switch='--plots', switch_ab='-p', help='Save plots of results', required=.false., act='store_true', def='.false.', &
               error=error)
  call cli%add(switch='--tserie', switch_ab='-t', help='Save time-serie-results', required=.false., act='store_true', &
               def='.false.', error=error)
  call cli%add(switch='--verbose', help='Verbose output', required=.false., act='store_true', def='.false.', error=error)
  ! parsing Command Line Interface
  call cli%parse(error=error)
  call cli%get(switch='--Ni', val=Ni, error=error) ; if (error/=0) stop
  call cli%get(switch='--order', val=order, error=error) ; if (error/=0) stop
  call cli%get(switch='--t_final', val=t_final, error=error) ; if (error/=0) stop
  call cli%get(switch='-r', val=results, error=error) ; if (error/=0) stop
  call cli%get(switch='-p', val=plots, error=error) ; if (error/=0) stop
  call cli%get(switch='-t', val=time_serie, error=error) ; if (error/=0) stop
  call cli%get(switch='--verbose', val=verbose, error=error) ; if (error/=0) stop
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine command_line_interface

  subroutine init()
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Initialize the field.
  !---------------------------------------------------------------------------------------------------------------------------------
  real(R_P), parameter   :: pi=4._R_P * atan(1._R_P) !< Pi greek.
  integer(I_P)           :: i                        !< Space counter.
  real(R_P)              :: rho_sin                  !< Sinusoidal density distribution.
  real(R_P)              :: Dx                       !< Space step discretization.
  real(R_P)              :: cp0(1:Ns)                !< Specific heat at constant pressure.
  real(R_P)              :: cv0(1:Ns)                !< Specific heat at constant volume.
  real(R_P), allocatable :: initial_state(:,:)       !< Initial state of primitive variables.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  allocate(x(1:Ni))
  allocate(initial_state(1:Np, 1:Ni))
  cp0(1) = 1040._R_P
  cv0(1) = 742.85_R_P
  Dx=1._R_P/Ni
  do i=1, Ni
    x(i) = Dx * i - 0.5_R_P * Dx
    if (x(i)<=0.12_R_P) then
      initial_state(:, i) = [3.857143_R_P, & ! rho(s)
                             2.629369_R_P, & ! u
                             10.33333_R_P, & ! p
                             3.857143_R_P, & ! sum(rho(s))
                             cp0/cv0]        ! gamma = cp/cv
    else
      rho_sin = 1._R_P + 0.2_R_P * sin (8._R_P * x(i) * 2._R_P * pi)
      initial_state(:, i) = [rho_sin, & ! rho(s)
                             0._R_P,  & ! u
                             1._R_P,  & ! p
                             rho_sin, & ! sum(rho(s))
                             cp0/cv0]   ! gamma = cp/cv
    endif
  enddo
  call rk_integrator%init(stages=rk_stages)
  call domain%init(Ni=Ni, Ns=Ns, Dx=Dx, BC_L='TRA', BC_R='TRA', initial_state=initial_state, cp0=cp0, cv0=cv0, ord=order)
  call save_time_serie(title='Shu-Osher shock tube problem',                                                           &
                       filename='shu-osher-order-'//trim(str(.true., order))//'-grid-'//trim(str(.true., Ni))//'.dat', &
                       t=t)
  t = 0._R_P
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine init

  subroutine finish()
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Peform after-success finishing operations.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  call save_time_serie(t=t, finish=.true.)
  call save_results(title='Shu-Osher shock tube problem', &
                    filename='shu-osher-order-'//trim(str(.true., order))//'-grid-'//trim(str(.true., Ni)))
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine finish

  subroutine save_results(title, filename)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Save results.
  !---------------------------------------------------------------------------------------------------------------------------------
  character(*), intent(IN) :: title            !< Plot title.
  character(*), intent(IN) :: filename         !< Output filename.
  real(R_P), allocatable   :: final_state(:,:) !< Final state.
  integer(I_P)             :: rawfile          !< Raw file unit for saving results.
  type(pyplot)             :: plt              !< Plot file handler.
  integer(I_P)             :: i                !< Counter.
  integer(I_P)             :: v                !< Counter.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (results.or.plots) final_state = domain%output()
  if (results) then
    open(newunit=rawfile, file=filename//'.dat')
    write(rawfile, '(A)')'# '//title
    write(rawfile, '(A)')'VARIABLES="x" "rho(1)" "u" "p" "rho" "gamma"'
    write(rawfile, '(A)')'ZONE T="'//str(n=t)//'"'
    do i=1, Ni
      write(rawfile, '('//trim(str(.true.,Np+1))//'('//FR_P//',1X))')x(i), (final_state(v, i), v=1, Np)
    enddo
    close(rawfile)
  endif
  if (plots) then
    call plt%initialize(grid=.true., xlabel='x', title=title)
    do v=1, Ns
      call plt%add_plot(x=x, y=final_state(v, :), label='rho('//trim(str(.true.,v))//')', linestyle='b-', linewidth=1)
    enddo
    call plt%add_plot(x=x, y=final_state(Ns+1, :), label='u', linestyle='r-', linewidth=1)
    call plt%add_plot(x=x, y=final_state(Ns+2, :), label='p', linestyle='g-', linewidth=1)
    call plt%add_plot(x=x, y=final_state(Ns+3, :), label='rho', linestyle='o-', linewidth=1)
    call plt%add_plot(x=x, y=final_state(Ns+4, :), label='gamma', linestyle='c-', linewidth=1)
    call plt%savefig(filename//'.png')
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine save_results

  subroutine save_time_serie(title, filename, finish, t)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Save time-serie results.
  !---------------------------------------------------------------------------------------------------------------------------------
  character(*), intent(IN), optional :: title    !< Plot title.
  character(*), intent(IN), optional :: filename !< Output filename.
  logical,      intent(IN), optional :: finish   !< Flag for triggering the file closing.
  real(R_P),    intent(IN)           :: t        !< Current integration time.
  real(R_P), allocatable             :: final_state(:,:) !< Final state.
  integer(I_P), save                 :: tsfile   !< File unit for saving time serie results.
  integer(I_P)                       :: i        !< Counter.
  integer(I_P)                       :: v        !< Counter.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (time_serie) then
    final_state = domain%output()
    if (present(filename).and.present(title)) then
      open(newunit=tsfile, file=filename)
      write(tsfile, '(A)')'# '//title
    endif
    write(tsfile, '(A)')'VARIABLES="x" "rho(1)" "u" "p" "rho" "gamma"'
    write(tsfile, '(A)')'ZONE T="'//str(n=t)//'"'
    do i=1, Ni
      write(tsfile, '('//trim(str(.true.,Np+1))//'('//FR_P//',1X))')x(i), (final_state(v, i), v=1, Np)
    enddo
    if (present(finish)) then
      if (finish) close(tsfile)
    endif
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine save_time_serie
endprogram integrate_euler_1D
