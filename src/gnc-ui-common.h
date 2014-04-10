/********************************************************************\
 * gnc-common.h -- define GUI independent items                     *
 *                                                                  *
 * Copyright (C) 1999, 2000 Rob Browning                            *
 *                                                                  *
 * This program is free software; you can redistribute it and/or    *
 * modify it under the terms of the GNU General Public License as   *
 * published by the Free Software Foundation; either version 2 of   *
 * the License, or (at your option) any later version.              *
 *                                                                  *
 * This program is distributed in the hope that it will be useful,  *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of   *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the    *
 * GNU General Public License for more details.                     *
 *                                                                  *
 * You should have received a copy of the GNU General Public License*
 * along with this program; if not, contact:                        *
 *                                                                  *
 * Free Software Foundation           Voice:  +1-617-542-5942       *
 * 59 Temple Place - Suite 330        Fax:    +1-617-542-2652       *
 * Boston, MA  02111-1307,  USA       gnu@gnu.org                   *
 *                                                                  *
\********************************************************************/

#ifndef __GNC_UI_COMMON_H__
#define __GNC_UI_COMMON_H__

#include "config.h"

#if defined(GNOME)
  #include <gtk/gtk.h>
#elif defined(MOTIF)
  #include <Xm/Xm.h>
#endif

#if defined(GNOME)
  typedef GtkWidget *gncUIWidget;
#elif defined(MOTIF)
  typedef Widget gncUIWidget;
#elif defined(KDE)
  typedef void *gncUIWidget;
#endif

#endif