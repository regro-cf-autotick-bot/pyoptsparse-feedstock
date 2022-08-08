@echo on

cd %SRC_DIR%
set NP_INC=%SP_DIR%\numpy\core\include
set CC=cl
set FC=flang
set CC_LD=link
set MESON_ARGS=-Dipopt_dir=%LIBRARY_PREFIX% -Dincdir_numpy=%NP_INC% -Dpython_target=%PYTHON% %EXTRA_FLAGS%
python -m build -n -x .
pip install --prefix "%PREFIX%" --no-deps --no-index --find-links dist pyoptsparse