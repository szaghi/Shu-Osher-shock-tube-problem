#!/usr/bin/make

#main building variables
DSRC    = src
DOBJ    = build/obj/
DMOD    = build/mod/
DEXE    = build/
LIBS    =
FC      = gfortran
OPTSC   =  -cpp -c -frealloc-lhs -O3  -J build/mod
OPTSL   =  -O3  -J build/mod
VPATH   = $(DSRC) $(DOBJ) $(DMOD)
MKDIRS  = $(DOBJ) $(DMOD) $(DEXE)
LCEXES  = $(shell echo $(EXES) | tr '[:upper:]' '[:lower:]')
EXESPO  = $(addsuffix .o,$(LCEXES))
EXESOBJ = $(addprefix $(DOBJ),$(EXESPO))

#auxiliary variables
COTEXT  = "Compiling $(<F)"
LITEXT  = "Assembling $@"

#building rules
$(DEXE)euler-1D: $(MKDIRS) $(DOBJ)euler-1d.o
	@rm -f $(filter-out $(DOBJ)euler-1d.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) euler-1D

#compiling rules
$(DOBJ)euler-1d.o: src/Euler-1D/euler-1D.f90 \
	$(DOBJ)ir_precision.o \
	$(DOBJ)type_euler-1d.o \
	$(DOBJ)data_type_command_line_interface.o \
	$(DOBJ)foodie.o \
	$(DOBJ)pyplot_module.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)type_euler-1d.o: src/Euler-1D/type_euler-1D.f90 \
	$(DOBJ)ir_precision.o \
	$(DOBJ)foodie.o \
	$(DOBJ)wenoof.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)foodie_adt_integrand.o: src/FOODIE/foodie_adt_integrand.f90 \
	$(DOBJ)foodie_kinds.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)foodie_integrator_tvd_runge_kutta.o: src/FOODIE/foodie_integrator_tvd_runge_kutta.f90 \
	$(DOBJ)foodie_kinds.o \
	$(DOBJ)foodie_adt_integrand.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)foodie_integrator_euler_explicit.o: src/FOODIE/foodie_integrator_euler_explicit.f90 \
	$(DOBJ)foodie_kinds.o \
	$(DOBJ)foodie_adt_integrand.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)foodie_kinds.o: src/FOODIE/foodie_kinds.f90
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)foodie_integrator_leapfrog.o: src/FOODIE/foodie_integrator_leapfrog.f90 \
	$(DOBJ)foodie_kinds.o \
	$(DOBJ)foodie_adt_integrand.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)foodie_integrator_adams_bashforth.o: src/FOODIE/foodie_integrator_adams_bashforth.f90 \
	$(DOBJ)foodie_kinds.o \
	$(DOBJ)foodie_adt_integrand.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)foodie_integrator_adams_moulton.o: src/FOODIE/foodie_integrator_adams_moulton.f90 \
	$(DOBJ)foodie_kinds.o \
	$(DOBJ)foodie_adt_integrand.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)foodie_integrator_low_storage_runge_kutta.o: src/FOODIE/foodie_integrator_low_storage_runge_kutta.f90 \
	$(DOBJ)foodie_kinds.o \
	$(DOBJ)foodie_adt_integrand.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)foodie.o: src/FOODIE/foodie.f90 \
	$(DOBJ)foodie_adt_integrand.o \
	$(DOBJ)foodie_integrator_adams_bashforth.o \
	$(DOBJ)foodie_integrator_adams_bashforth_moulton.o \
	$(DOBJ)foodie_integrator_adams_moulton.o \
	$(DOBJ)foodie_integrator_embedded_runge_kutta.o \
	$(DOBJ)foodie_integrator_euler_explicit.o \
	$(DOBJ)foodie_integrator_leapfrog.o \
	$(DOBJ)foodie_integrator_low_storage_runge_kutta.o \
	$(DOBJ)foodie_integrator_tvd_runge_kutta.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)foodie_integrator_embedded_runge_kutta.o: src/FOODIE/foodie_integrator_embedded_runge_kutta.f90 \
	$(DOBJ)foodie_kinds.o \
	$(DOBJ)foodie_adt_integrand.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)foodie_integrator_adams_bashforth_moulton.o: src/FOODIE/foodie_integrator_adams_bashforth_moulton.f90 \
	$(DOBJ)foodie_kinds.o \
	$(DOBJ)foodie_adt_integrand.o \
	$(DOBJ)foodie_integrator_adams_bashforth.o \
	$(DOBJ)foodie_integrator_adams_moulton.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)wenoof.o: src/WenOOF/wenoof.f90 \
	$(DOBJ)type_weno_interpolator.o \
	$(DOBJ)type_weno_interpolator_upwind.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)wenoof_kinds.o: src/WenOOF/wenoof_kinds.f90
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)type_weno_interpolator.o: src/WenOOF/type_weno_interpolator.f90 \
	$(DOBJ)wenoof_kinds.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)type_weno_interpolator_upwind.o: src/WenOOF/type_weno_interpolator_upwind.f90 \
	$(DOBJ)wenoof_kinds.o \
	$(DOBJ)type_weno_interpolator.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)ir_precision.o: src/IR_Precision/IR_Precision.f90
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)pyplot_module.o: src/pyplot-fortran/pyplot_module.f90
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)data_type_command_line_interface.o: src/FLAP/Data_Type_Command_Line_Interface.F90 \
	$(DOBJ)ir_precision.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

#phony auxiliary rules
.PHONY : $(MKDIRS)
$(MKDIRS):
	@mkdir -p $@
.PHONY : cleanobj
cleanobj:
	@echo deleting objects
	@rm -fr $(DOBJ)
.PHONY : cleanmod
cleanmod:
	@echo deleting mods
	@rm -fr $(DMOD)
.PHONY : cleanexe
cleanexe:
	@echo deleting exes
	@rm -f $(addprefix $(DEXE),$(EXES))
.PHONY : clean
clean: cleanobj cleanmod
.PHONY : cleanall
cleanall: clean cleanexe
