### Coverage analysis of *type_euler-1D.f90*

|Metrics|||
| --- | --- | --- |
|Number of executable lines          |266||
|Number of executed lines            |196|74%|
|Number of unexecuted lines          |70|26%|
|Average hits per executed line      |6290494||
|Number of procedures                |28||
|Number of executed procedures       |18|64%|
|Number of unexecuted procedures     |10|36%|
|Average hits per executed procedure |5086060||

 --- 
[![lines](http://www.google.com/chart?cht=p&chs=300x150&chd=s:tQ&chtt=Coverage%20of%20executable%20lines&chdl=Executed%7cUnexecuted&chco=65C1FF|FF9260&chl=74%25%7c26%25)]()
[![procedures](http://www.google.com/chart?cht=p&chs=300x150&chd=s:nW&chtt=Coverage%20of%20procedures&chdl=Executed%7cUnexecuted&chco=65C1FF|FF9260&chl=64%25%7c36%25)]()

#### Unexecuted procedures

 + *function* **euler_local_error**, line 361
 + *function* **euler_multiply_euler**, line 391
 + *function* **output**, line 236
 + *function* **p**, line 937
 + *function* **r**, line 953
 + *function* **real_multiply_euler**, line 452
 + *function* **sub_euler**, line 513
 + *subroutine* **destroy**, line 212
 + *subroutine* **euler_assign_real**, line 588
 + *subroutine* **finalize**, line 874

#### Executed procedures

 + *function* **a**: tested **20564088** times
 + *function* **conservative2primitive**: tested **11317248** times
 + *function* **eigen_vect_L**: tested **9928380** times
 + *function* **eigen_vect_R**: tested **9928380** times
 + *function* **fluxes**: tested **9915486** times
 + *function* **E**: tested **9915486** times
 + *function* **H**: tested **9915486** times
 + *subroutine* **riemann_solver**: tested **4957743** times
 + *subroutine* **compute_inter_states**: tested **4957743** times
 + *subroutine* **euler_assign_euler**: tested **55260** times
 + *function* **euler_multiply_real**: tested **40524** times
 + *function* **add_euler**: tested **25788** times
 + *function* **dEuler_dt**: tested **12894** times
 + *subroutine* **impose_boundary_conditions**: tested **6447** times
 + *subroutine* **reconstruct_interfaces_states**: tested **6447** times
 + *function* **compute_dt**: tested **921** times
 + *function* **primitive2conservative**: tested **768** times
 + *subroutine* **init**: tested **2** times

 --- 
 Report generated by [FoBiS.py](https://github.com/szaghi/FoBiS)