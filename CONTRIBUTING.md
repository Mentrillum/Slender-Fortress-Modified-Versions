## Contribution Guidelines

When making a PR (Pull request) to contribute changing Slender Fortress Modified in any way, there are critical requirements and specific circumstances you may need to be careful about.

- Obviously ensure the code works before pushing a PR and make sure no warnings exist.
- Follow the code guidelines, if you'd like to make specific code up to date with these standards that may be missed while making your own features, feel free to update the code.
- In 1.7.4.2, ensure your code can compile in Sourcemod 1.10. In 1.7.5 when that comes out, make sure the code can compile in Sourcemod 1.11.
- Features that are seen by members of the community as unfitting for Slender Fortress, even in the Modified versions, can and in most cases will result in a PR denial. Things like adding nativs and forwards, quality of life developer changes, fixes, translations, anything not a new feature will likely not result in a PR denial. However adding a new feature relating to gameplay will be reviewed by members of the community who have best interests in Slender Fortress if the feature seems questionable.

## Code Guidelines

> ⚠️ Currently not all parts of the codebase are following these guidelines. If you are contributing, make sure any code you are adding or modifying adheres to these guidelines. **Do not change more than you need to minimize merge conflicts.**

### General

- Always use tabs for indentation.
- Always use semicolons to end statements.
- Functions, enums, structs, methodmaps, and variables must follow a `camelCase` naming convention.
- Functions, enums, structs, methodmaps, and global variables must always be capitalized. (For instance GetEntityClassname, SF2BossProfileSoundInfo, g_Gravity)
- Do not capitalize local variables.
- Global variables must be prefixed with `g_`.
- Functions and global variables that are not meant to be used outside their defined file should be marked with the `static` keyword.
- Never use the `public` keyword unless used for a SourceMod/extension/plugin forward.
- Never use the `stock` keyword. It allows the compiler to tell us which functions are unused.
- Never use the `break` keyword. Instead, ensure that your loop condition is the one that exits your loop appropriately.
- Refrain from using the `continue` keyword. Do not use it for small loops, only for larger ones, if appropriate. This will be up to the descretion of reviewers of your code.
- Global ConVar variable names should be `g_(variable name)ConVar`
- Global Offset variable names should be `g_(variable name)Offset`
- Global and Private forward variable names should be `g_(variable name)Fwd`
- Global Dynamic Hook variable names should be `g_DHook(variable name)`
- Do not use Handle array functions
- Do not leave multiple blank lines (Use the VSCode extension **"Remove empty lines"** if necessary)
- Do not leave empty blank lines with indentations or unnecessary whitespacing (Use the VSCode extension **"empty-indent"** to solve most loose indentation)

### Scopes

- For conditionals and loops, there must be a space between the keyword and the enclosed statement.

`for(statement)` - ❌

`for (statement)` - ✔️

`if(statement)` - ❌

`if (statement)` - ✔️

- Opening and closing braces must always start on a new line.

`if (statement){` - ❌

`if (statement) {` - ❌

`if (statement) { return 2; }` - ❌❌

`} else {` - ❌❌❌

`}` - ✔️

- Scopes with no braces are not allowed.

❌:
```
if (statement)
	return true;
```

✔️:
```
if (statement)
{
	return true;
}
```
