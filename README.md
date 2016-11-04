
This package contains a collection of utilities for working with shells
in Emacs.  The list is as follows:
  1. Split and open a new shell either horizontally or vertically.
  2. Open the new shell in the current working directory from where the
     split is made.
  3. Given a server name as input, open a new shell and rsh to the server.
     This could be taken as the prefix argument to the other commands.
     Also rename the shell according to server name.
  4. Switch between shell buffers quickly (only show shell buffers in switch).
     Use helm/counsel to show the open shell buffers.
  5. Use perspective-mode or bookmarks to save shell window configurations
     and easy switch amongst them.
  6. Open special command in ansi-term when possible like what eshell does.
     Special commands include: vim, less, watch etc.
  7. Use a global counter to number the shells as it will be overall good.
  8. Provide an API to get new shell using shutil (so that counter is set).
  
(Under progress)
