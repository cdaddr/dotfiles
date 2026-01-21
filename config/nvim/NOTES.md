# Notes

This file is for useful vim things I learn and want not to forget.

- `:lua =foo`  => `:lua vim.print(vim.inspect(foo))`

- Quick insert in Command mode :
    ```vim
    CTRL-R CTRL-F				*c_CTRL-R_CTRL-F* *c_<C-R>_<C-F>*
    CTRL-R CTRL-P				*c_CTRL-R_CTRL-P* *c_<C-R>_<C-P>*
    CTRL-R CTRL-W				*c_CTRL-R_CTRL-W* *c_<C-R>_<C-W>*
    CTRL-R CTRL-A				*c_CTRL-R_CTRL-A* *c_<C-R>_<C-A>*
    CTRL-R CTRL-L				*c_CTRL-R_CTRL-L* *c_<C-R>_<C-L>*
            Insert the object under the cursor:
                CTRL-F	the Filename under the cursor
                CTRL-P	the Filename under the cursor, expanded with
                    'path' as in |gf|
                CTRL-W	the Word under the cursor
                CTRL-A	the WORD under the cursor; see |WORD|
                CTRL-L	the line under the cursor
    ```

