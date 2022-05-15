/* See LICENSE file for copyright and license details. */
/* Default settings; can be overriden by command line. */

static int topbar = 1;                      /* -b  option; if 0, dmenu appears at bottom     */
/* -fn option overrides fonts[0]; default X11 font or font set */
static const char *fonts[] = {
	"Ubuntu Mono:Regular:pixelsize=13"    /* "monospace:size=10" */
};
static const char *prompt      = NULL;      /* -p  option; prompt to the left of input field */
static const char *colors[SchemeLast][2] = {
	/*     fg         bg       */
	[SchemeNorm] = { "#FFFFFF", "#000000" },             /* "#bbbbbb", "#222222" */
	[SchemeSel] = { "#FFFFFF", "#7F7F7F" },              /* "#eeeeee", "#005577" */
	[SchemeSelHighlight] = { "#FFFF00", "#7F7F7F" },     /* "#ffc978", "#005577" */ 
	[SchemeNormHighlight] = { "#FFFF00", "#171421" },    /* "#ffc978", "#222222" */
	[SchemeOut] = { "#000000", "#00ffff" },
	[SchemeOutHighlight] = { "#ffc978", "#00ffff" },
};
/* -l option; if nonzero, dmenu uses vertical list with given number of lines */
static unsigned int lines      = 0;
/* -h option; minimum height of a menu line */
static unsigned int lineheight = 20;
static unsigned int min_lineheight = 8;

/*
 * Characters not considered part of a word while deleting words
 * for example: " /?\"&[]"
 */
static const char worddelimiters[] = " ";
