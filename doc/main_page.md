project: Shu-Osher-shock-tube-problem
project_dir: ./src/
output_dir: ./doc/html/publish/
project_github: https://github.com/szaghi/Shu-Osher-shock-tube-problem
summary: Regression-test results of Shu-Osher shock tube problem
author: Stefano Zaghi
github: https://github.com/szaghi
website: https://github.com/szaghi
md_extensions: markdown.extensions.toc(anchorlink=True)
               markdown.extensions.smarty(smart_quotes=False)
               markdown.extensions.extra
               markdown_checklist.extension
docmark: <
display: public
         protected
         private
source: true
warn: true
graph: true
extra_mods: iso_fortran_env:https://gcc.gnu.org/onlinedocs/gfortran/ISO_005fFORTRAN_005fENV.html

{!README.md!}
