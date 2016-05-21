### Notes on exporting vecmath sketches

There is issue exporting sketches with the vecmath library, but there is a workaround:-
cd MvApp.app
mkdir lib/library/lib
mv lib/rpextras.jar lib/library/lib
edit lib/library/vecmath.rb to `require_relative 'lib/rpextras'`



