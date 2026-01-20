import os
import socket

from kitty.boss import get_boss
from kitty.fast_data_types import Screen
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    Formatter,
    TabBarData,
    TabAccessor,
    as_rgb,
    draw_attributed_string,
    draw_tab_with_separator,
)


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    active_id = get_boss().active_tab.id
    active_tab = TabAccessor(active_id)

    # Draw the application cell on the far left for the first tab
    old_fg = screen.cursor.fg
    old_bg = screen.cursor.bg
    if index == 1:
        title = active_tab.active_oldest_exe
        screen.cursor.italic = False
        screen.cursor.bold = False
        screen.cursor.bg = as_rgb(int(draw_data.default_bg))
        screen.cursor.fg = as_rgb(int(draw_data.inactive_fg))
        cell = f" 󰖲 {title} "
        screen.draw(cell)

    screen.cursor.fg = old_fg
    screen.cursor.bg = old_bg
    draw_tab_with_separator(
        draw_data,
        screen,
        tab,
        before,
        max_title_length,
        index,
        is_last,
        extra_data,
    )

    if is_last:
        draw_right_status(draw_data, screen, active_tab)
    return screen.cursor.x


def draw_right_status(
    draw_data: DrawData, screen: Screen, active_tab: TabAccessor
) -> None:
    """
    Draw the cells on the rhs.
    """
    # The tabs may have left some formats enabled. Disable them now.
    draw_attributed_string(Formatter.reset, screen)
    cells = create_cells(active_tab)
    # Drop cells that wont fit
    while True:
        if not cells:
            return
        padding = (
            screen.columns
            - screen.cursor.x
            - sum(len(c[0]) + len(c[1]) + 5 for c in cells)
            - max(len(cells) - 1, 0)
        )
        if padding >= 0:
            break
        cells = cells[1:]

    if padding:
        screen.draw(" " * padding)

    screen.cursor.bg = as_rgb(int(draw_data.inactive_bg))
    symbol_fg = as_rgb(int(0x54546D))
    for cell in cells:
        title, symbol, color = cell
        # Draw the separator
        if cell != cells[0]:
            screen.cursor.fg = symbol_fg
            screen.draw("  ")
        screen.cursor.fg = symbol_fg
        screen.draw(f"{symbol}")
        screen.cursor.fg = as_rgb(color)
        screen.draw(f" {title}")


def create_cells(active_tab: TabAccessor) -> list[tuple[str, str]]:
    """
    Create cells to display on the rhs.
    """
    username = os.environ.get("USER") or os.environ.get("USERNAME") or "?"
    hostname = os.environ.get("HOSTNAME") or socket.gethostname() or "?"
    cwd = active_tab.active_oldest_wd or "?"
    if cwd and isinstance(cwd, str):
        home = os.path.expanduser("~")
        if cwd.startswith(home):
            cwd = "~" + cwd[len(home) :]
        if len(cwd) > 30:
            last_component = os.path.basename(cwd.rstrip("/"))
            if len(last_component) > 30:
                cwd = last_component[:30] + "…"
            else:
                cwd = last_component

    return [
        (username, "", 0x957fb8),
        (hostname, "󰒋", 0x957fb8),
        # (cwd, "", 0x7e9cd8),
    ]
