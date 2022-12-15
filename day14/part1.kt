import java.io.File

var solved: Boolean = false

class Tile(val x: Int, val y: Int) {
    private var right: Tile? = null
    private var bottom: Tile? = null
    private var left: Tile? = null
    private var top: Tile? = null
    var set: Boolean = false

    companion object {
        var tiles: HashMap<Int, HashMap<Int, Tile>> = HashMap()
        private var built: Boolean = false
        private var depths: Int = 0

        fun tilesPut(tile: Tile) {
            var dest: HashMap<Int, Tile>? = tiles[tile.x]
            if (dest == null) {
                dest = HashMap()
                tiles[tile.x] = dest
            }
            dest[tile.y] = tile
        }

        fun getTile(x: Int, y: Int): Tile {
            return tiles[x]?.get(y) ?: Tile(x, y)
        }

        fun built() {
            built = true
        }
    }

    init {
        if (!built) {
            depths = depths.coerceAtLeast(y)
        } else if (y > depths + 3) {
            solved = true
        }
        tilesPut(this)
        setupLinks()
    }

    fun left(): Tile {
        return if (left == null) {
            val t: Tile = Tile(x-1, y)
            t.setupLinks()
            t
        } else {
            left!!
        }
    }

    fun right(): Tile {
        return if (right == null) {
            val t: Tile = Tile(x+1, y)
            t.setupLinks()
            t
        } else {
            right!!
        }
    }

    fun bottom(): Tile {
        return if (bottom == null) {
            val t: Tile = Tile(x, y+1)
            t.setupLinks()
            t
        } else {
            bottom!!
        }
    }

    fun top(): Tile {
        return if (top == null) {
            val t: Tile = Tile(x, y-1)
            t.setupLinks()
            t
        } else {
            top!!
        }
    }

    fun set() {
        set = true
    }

    private fun setupLinks() {
        var t: Tile? = tiles[x+1]?.get(y)
        if (t != null) {
            right = t
            t.left = this
        }
        t = tiles[x-1]?.get(y)
        if (t != null) {
            left = t
            t.right = this
        }
        t = tiles[x]?.get(y+1)
        if (t != null) {
            bottom = t
            t.top = this
        }
        t = tiles[x]?.get(y-1)
        if (t != null) {
            top = t
            t.bottom = this
        }
    }
}

fun main(args: Array<String>) {
    File("input.txt").inputStream().bufferedReader().forEachLine { line ->
        val nodes: List<String> = line.split(" -> ")
        var index = 0
        while (index < nodes.size - 1) {
            var tile: Tile = Tile.getTile(
                nodes[index].split(",")[0].toInt(),
                nodes[index].split(",")[1].toInt()
            )
            var Xend: Int = nodes[index + 1].split(",")[0].toInt()
            var Yend: Int = nodes[index + 1].split(",")[1].toInt()
            while ((tile.x != Xend) || (tile.y != Yend)) {
                tile.set()
                if (tile.x > Xend) tile = tile.left()
                if (tile.x < Xend) tile = tile.right()
                if (tile.y > Yend) tile = tile.top()
                if (tile.y < Yend) tile = tile.bottom()
            }
            tile.set()
            index++
        }
    }
    Tile.built()
    val source: Tile = Tile.getTile(500, 0)
    var sand: Tile
    var resting: Int = 0
    out@ while (true) {
        sand = source
        while (true) {
            if (!sand.bottom().set) {
                sand = sand.bottom()
            } else if (!sand.bottom().left().set) {
                sand = sand.bottom().left()
            } else if (!sand.bottom().right().set) {
                sand = sand.bottom().right()
            } else {
                sand.set()
                break
            }

            if (solved) {
                break@out
            }
        }
        resting++
    }
    println(resting)
}