Translations
============

The application can be easily be translated into other languages. Here's how we handle those translations.

Files and Folders
-----------------

### BeTrains.pro

The main project file takes care of generating `.qm` files from the source `.ts` files. It is mostly automated.

### BeTrains.qrc

This resource file must be updated whenever a new translation is added. Please note that files must end with `.qm`, not `.ts`.

    <qresource prefix="/i18n">
        <file alias="BeTrains.en.qm">i18n/BeTrains.en.qm</file>
        <file alias="BeTrains.nl.qm">i18n/BeTrains.nl.qm</file>
    </qresource>

### i18n/

This directory contains all translations. Filenames must adhere to this format:

    BeTrains.xx_YY.ts or BeTrains.xx.ts

#### Source file

`i18n/BeTrains.en.ts` is a treated in a special way. It is used as the source for all other translations. Whenever a string in the code is change this file must be updated to reflect those changes. Usually, this can be accomplished by running `lupdate`, after which the file can get pushed to Transifex (see below).



Syncing with Transifex
----------------------

We are using http://transifex.net as a frontend for translating the client, use the "transifex client":http://help.transifex.net/features/client/index.html to fetch new translations from transifex.

### Pushing new source strings

1. `lupdate -no-obsolete -pro BeTrains.pro -ts i18n/BeTrains.en.ts`
2. Fill in plural forms (use Qt Linquist, or manually edit `numerus="yes"` entries)
3. `tx push -s`


### Fetching new translations

1. `tx pull -a`
2. Update `BeTrains.qrc`
3. `git add` new translations from `i18n/`
