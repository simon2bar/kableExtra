#' Wrapper function of knitr::kable
#'
#' @description knitr's kable function is the foundation of this package.
#' However, it has many latex/html specific arguments hidden under the ground
#' unless you check its source code. This wrapper function is created to
#' provide better documentation (and auto-complete yay) and at the same time,
#' solve the auto format setting in a better way.
#'
#' @param table.attr A character string for addition HTML table attributes.
#' This is convenient if you simply want to add a few HTML classes or styles.
#' For example, you can put 'class="table" style="color: red"'.
#' @param booktabs T/F for whether to enable the booktabs format for tables. I
#' personally would recommend you turn this on for every latex table except
#' some special cases.
#' @param longtable T/F for whether to use the longtable format. If you have a
#' table that will span over two or more pages, you will have to turn this on.
#' @param valign You probably won't need to adjust this latex option very often.
#' If you are familar with latex tables, this is the optional position for the
#' tabular environment controling the vertical position of the table relative
#' to the baseline of the surrounding text. Possible choices are `b`, `c` and
#' `t` (default).
#' @param position This is the "real" or say floating position for the latex
#' table environment. The `kable` only puts tables in a table environment when
#' a caption is provided. That is also the reason why your tables will be
#' floating around if you specify captions for your table. Possible choices are
#' `h` (here), `t` (top, default), `b` (bottom) and `p` (on a dedicated page).
#' @param centering T (default)/F. Whether to center tables in the table
#' environment.
#' @param caption.short Another latex feature. Short captions for tables
#' @param linesep By default, in booktabs tables, `kable` insert an extra space
#' every five rows for clear display. If you don't want this feature or if you
#' want to do it in a different pattern, you can consider change this option.
#' The default is c('', '', '', '', '\\addlinespace'). Also, if you are not
#' using booktabs, but you want a cleaner display, you can change this to ''.
#' @param table.envir You probably don't need to change this as well. The
#' default setting is to put a table environment outside of tabular if a
#' caption is provided.
#' @param vline vertical separator. Default is nothing for booktabs
#' tables but "|" for normal tables.
#' @param toprule toprule. Default is hline for normal table but toprule for
#' booktabs tables.
#' @param bottomrule bottomrule. Default is hline for normal table but
#' bottomrule for booktabs tables.
#' @param midrule midrule. Default is hline for normal table but midrule for
#' booktabs tables.
#'
#' @inheritParams knitr::kable
#' @export
kbl <- function(x, format, digits = getOption("digits"),
                row.names = NA, col.names = NA, align,
                caption = NULL, label = NULL, format.args = list(),
                escape = TRUE,
                table.attr = '',
                booktabs = FALSE, longtable = FALSE,
                valign = 't', position = '', centering = TRUE,
                vline = getOption('knitr.table.vline', if (booktabs) '' else '|'),
                toprule = getOption('knitr.table.toprule', if (booktabs) '\\toprule' else '\\hline'),
                bottomrule = getOption('knitr.table.bottomrule', if (booktabs) '\\bottomrule' else '\\hline'),
                midrule = getOption('knitr.table.midrule', if (booktabs) '\\midrule' else '\\hline'),
                linesep = if (booktabs) c('', '', '', '', '\\addlinespace') else '\\hline',
                caption.short = '',
                table.envir = if (!is.null(caption)) 'table', ...) {
  if (!missing(align) && length(align) == 1L && !grepl('[^lcr]', align)) {
    align <- strsplit(align, '')[[1]]
  }
  if (missing(format) || is.null(format)) {
    if (knitr::is_latex_output()) {
      format <- "latex"
      out <- knitr::kable(
        x = x, format = format, digits = digits,
        row.names = row.names, col.names = col.names, align = align,
        caption = caption, label = label, format.args = format.args,
        escape = escape,
        booktabs = booktabs, longtable = longtable,
        valign = valign, position = position, centering = centering,
        vline = vline, toprule = toprule, bottomrule = bottomrule,
        midrule = midrule, linesep = linesep, caption.short = caption.short,
        table.envir = table.envir, ...
      )
      table_info <- magic_mirror(out)
      if (is.null(col.names)) {
        table_info$position_offset <- 0
      }
      return(out)
    } else {
      format <- "html"
      out <- knitr::kable(
        x = x, format = format, digits = digits,
        row.names = row.names, col.names = col.names, align = align,
        caption = caption, label = label, format.args = format.args,
        escape = escape,
        table.attr = table.attr, ...
      )
      if (!"kableExtra" %in% class(out)) class(out) <- c("kableExtra", class(out))
      return(out)
    }
  } else {
    if (format == "latex") {
      out <- knitr::kable(
        x = x, format = format, digits = digits,
        row.names = row.names, col.names = col.names, align = align,
        caption = caption, label = label, format.args = format.args,
        escape = escape,
        booktabs = booktabs, longtable = longtable,
        valign = valign, position = position, centering = centering,
        vline = vline, toprule = toprule, bottomrule = bottomrule,
        midrule = midrule, linesep = linesep, caption.short = caption.short,
        table.envir = table.envir, ...
      )
      table_info <- magic_mirror(out)
      if (is.null(col.names)) {
        table_info$position_offset <- 0
      }
      return(out)
    }
    if (format == "html") {
      out <- knitr::kable(
        x = x, format = format, digits = digits,
        row.names = row.names, col.names = col.names, align = align,
        caption = caption, label = label, format.args = format.args,
        escape = escape,
        table.attr = table.attr, ...
      )
      if (!"kableExtra" %in% class(out)) class(out) <- c("kableExtra", class(out))
      return(out)
    }
    return(knitr::kable(
      x = x, format = format, digits = digits,
      row.names = row.names, col.names = col.names, align = align,
      caption = caption, label = label, format.args = format.args,
      escape = escape, ...
    ))
  }
}
