message( '\tEstableciendo plantilla de gráficos' )


# Preliminares --------------------------------------------------------------------------------
tam_letra <- rel( 0.9 )
tam_letra_tit <- rel( 1.0 )
tam_letra_lab <- rel( 0.9 )

tipo_letra <- "Times New Roman"
base_family_2 <- "sans"
graf_point_size <- 0.15
graf_line_size <- 0.6
graf_grid_major_size <- 0.25
graf_grid_minor_size <- 0.20
#graf_width <- 11
graf_width <- 13
graf_height <- 9
graf_units <- 'cm'
graf_dpi <- 300

## color definitions
main_color <- "white"
grid_color <- "grey60"
line_color <- parametros$iess_blue
text_color <- "black"

## plot size definitions
custom_base_size <- 10
plot_margin <- c( 2, 2, 2, 2 )
panel_border_size <- rel( 0.8 )
strip_text_size <- rel( 0.8 )

# Estilo sin leyenda -------------------------------------------------------------------------------
plt_theme <- theme( text = element_text( color = 'black' ),
                    panel.grid.major.x = element_line( colour = "grey85", size = graf_grid_major_size, linetype = 3 ),
                    panel.grid.major.y = element_line( colour = "grey85", size = graf_grid_major_size, linetype = 3 ),
                    panel.grid.minor.x = element_line( colour = "grey85", size = graf_grid_minor_size, linetype = 3 ),
                    panel.grid.minor.y = element_line( colour = "grey85", size = graf_grid_minor_size, linetype = 3 ),
                    legend.title = element_blank(),
                    legend.position = 'none',
                    legend.text = element_text( size = tam_letra_lab, colour = 'black',
                                                face = 'plain', family = tipo_letra),
                    #legend.margin = margin(t = 0.2,b=0.2, unit='cm'),
                    # legend.key.size = unit( 0.25, "cm" ),
                    plot.title = element_text( size = tam_letra_tit, colour = 'black',
                                               face = 'plain', family = tipo_letra,
                                               hjust = 0.5 , vjust = 0.5 ),
                    axis.title.x = element_text( face = 'plain', angle = 0, colour = 'black', 
                                                 size = tam_letra_lab, family = tipo_letra, 
                                                 vjust = 0, hjust = 0.5,
                                                 margin = margin( t = 4, r = 0, b = 0, l = 0 ) ),
                    axis.title.y = element_text( face = 'plain', angle = 90, colour = 'black', 
                                                 size = tam_letra_lab, family = tipo_letra, 
                                                 vjust = 0, hjust = 0.5,
                                                 margin = margin(t = 0, r = 10, b = 0, l = 0) ),
                    axis.text.x = element_text( face = 'plain', angle = 0, colour = 'black', 
                                                size = tam_letra, family = tipo_letra, 
                                                vjust = 0, hjust = 0.5 ),
                    axis.text.y = element_text( face = 'plain', angle = 0, colour = 'black', 
                                                size = tam_letra, family = tipo_letra, 
                                                vjust = 0, hjust = 0.5 ),
                    plot.margin = unit( plot_margin, "mm" ),
                    legend.box.margin = margin(-20,0,-6,0)
)

# Estilo con leyenda -------------------------------------------------------------------------------
plt_theme_legend <- theme( text = element_text( color = 'black' ),
                           panel.grid.major.x = element_line( colour = "grey85", size = graf_grid_major_size, linetype = 3 ),
                           panel.grid.major.y = element_line( colour = "grey85", size = graf_grid_major_size, linetype = 3 ),
                           panel.grid.minor.x = element_line( colour = "grey85", size = graf_grid_minor_size, linetype = 3 ),
                           panel.grid.minor.y = element_line( colour = "grey85", size = graf_grid_minor_size, linetype = 3 ),
                           plot.margin = unit( plot_margin, "mm" ),
                           legend.title = element_blank(),
                           legend.position = 'bottom',
                           legend.text = element_text( size = tam_letra_lab, colour = 'black', 
                                                       face = 'plain', family = tipo_letra ),
                           # legend.margin = unit( 0.5, "cm" ),
                           # legend.key.size = unit( 0.25, "cm" ),
                           plot.title = element_text( size = tam_letra_tit, colour = 'black',
                                                      face = 'plain', family = tipo_letra,
                                                      hjust = 0.5 , vjust = 0.5 ),
                           axis.title.x = element_text( face = 'plain', angle = 0, colour = 'black', 
                                                        size = tam_letra_lab, family = tipo_letra, 
                                                        vjust = 0, hjust = 0.5,
                                                        margin = margin( t = 10, r = 0, b = 0, l = 0 ) ),
                           axis.title.y = element_text( face = 'plain', angle = 90, colour = 'black', 
                                                        size = tam_letra_lab, family = tipo_letra, 
                                                        vjust = 0, hjust = 0.5,
                                                        margin = margin(t = 0, r = 10, b = 0, l = 0) ),
                           axis.text.x = element_text( face = 'plain', angle = 0, colour = 'black', 
                                                       size = tam_letra, family = tipo_letra, 
                                                       vjust = 0, hjust = 0.5 ),
                           axis.text.y = element_text( face = 'plain', angle = 0, colour = 'black', 
                                                       size = tam_letra, family = tipo_letra, 
                                                       vjust = 0, hjust = 0.5 )
)

# Theme Time-Series -----------------------------------------------------------------------------
# Almost the same as scatterplot theme but legend title is blank considering that the variables are
# often of different types (legend would plot the generic term "variable")

iess_timeseries_theme <-
  ggthemes::theme_foundation( base_size = custom_base_size, base_family = base_family_2 ) +
  theme(
# Plot ---------------------------------------------------------------------------------------------
    text = element_text( color = text_color ), 
    line = element_line( color = line_color ), 
    plot.title = element_text( hjust = 0, size = tam_letra_tit, family = tipo_letra ),
    # plot.subtitle = element_text( size = plot_subtitle_size ), # center
    # plot.caption = element_text( size = plot_caption_size ), # center
    plot.background = element_rect( color = main_color, fill = main_color  ),
    rect = element_rect( fill = main_color, color = NA, linetype = "solid" ),
    plot.margin = unit( plot_margin, "mm" ),
    
# Panel --------------------------------------------------------------------------------------------
    panel.border = element_rect( colour = line_color, size = panel_border_size ),
    panel.background = element_rect( linetype = "blank" ),
    panel.spacing = unit( 0.25, "lines" ), # this controls spacing between graphs when faceting
    
# Grid ---------------------------------------------------------------------------------------------
    panel.grid.minor.x = element_blank(),
    panel.grid.major.x = element_line( color = grid_color, size = graf_grid_major_size, linetype = 3 ),
    panel.grid.minor.y = element_blank(),
    panel.grid.major.y = element_line( color = grid_color, size = graf_grid_major_size, linetype = 3 ), 
    
# Axis ---------------------------------------------------------------------------------------------
    axis.text = element_text( size = tam_letra, family = tipo_letra ), 
    # axis.text.x = element_text( vjust = 0, margin = margin( t = tam_letra_lab, unit = "pt" ) ),
    # axis.text.y = element_text( hjust = 0, margin = margin( r = tam_letra_lab, unit = "pt" ) ),
    axis.title = element_text( size = tam_letra_lab, family = tipo_letra ),
    axis.title.x = element_text(),
    axis.title.y = element_text( angle = 90 ),
    # axis.line = element_line( size = axis_line_size ),
    axis.line.y = element_blank( ),
    axis.ticks = element_line( ),
    axis.ticks.y = element_blank( ),
    # axis.ticks.length = unit(  -1/32, "in" ),
    # axis.ticks.length = unit(  -custom_base_size * 0.5, "points" ),
    
# Legend -------------------------------------------------------------------------------------------
    legend.position = 'bottom',
    # legend.margin = unit( 0.5, "cm" ),
    # legend.justification = "right",
    legend.direction = NULL,
    # legend.background = element_rect( linetype = "blank" ),
    legend.spacing = unit( custom_base_size * 1.5, "points" ),
    legend.key = element_rect( linetype = "blank" ),
    # legend.key.size = unit( 0.25, "cm" ),
    legend.key.height = NULL,
    legend.key.width = NULL,
    legend.text = element_text( size = tam_letra_lab, colour = 'black', 
                                face = 'plain', family = tipo_letra ),
    legend.text.align = NULL,
    legend.title = element_blank(),
    legend.title.align = NULL,
    
# Strip --------------------------------------------------------------------------------------------
    strip.background = element_rect( fill = parametros$iess_blue, 
                                     color = "red",
                                     linetype = "blank" ),
    strip.text = element_text( size = strip_text_size, color = "white", family = tipo_letra ),
    strip.text.x = element_text( ),
    strip.text.y = element_text( angle = -90 ),
    
    complete = TRUE
  )
