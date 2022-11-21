--#CSGO
local args = {...}

local username = args[1]
local role = args[2]
local uid = args[3]

client.color_log(200,69,0,"[Master Loader] Welcome");

local rage_svg = renderer.load_svg("<svg width=\"55\" height=\"55\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\"><path fill=\"rgb(7,7,7)\" stroke=\"rgb(7,7,7)\" stroke-width=\"1\" opacity=\"1\" d=\"M 19.5 14 L 17.5 17 L 17 15 L 19.5 14 Z \"></path><path fill=\"rgb(7,7,7)\" stroke=\"rgb(7,7,7)\" stroke-width=\"1\" opacity=\"1\" d=\"M 45.5 16 L 43.5 19 L 35 18.5 Q 42.4 19.4 45.5 16 Z \"></path><path fill=\"rgb(7,7,7)\" stroke=\"rgb(7,7,7)\" stroke-width=\"1\" opacity=\"1\" d=\"M 35.5 20 L 36 23.5 L 35 23.5 L 35.5 20 Z \"></path><path fill=\"rgb(7,7,7)\" stroke=\"rgb(7,7,7)\" stroke-width=\"1\" opacity=\"1\" d=\"M 46.5 20 L 47 22 L 45 21.5 L 46.5 20 Z \"></path><path fill=\"rgb(7,7,7)\" stroke=\"rgb(7,7,7)\" stroke-width=\"1\" opacity=\"1\" d=\"M 49.5 20 L 50 22 L 48 21.5 L 49.5 20 Z \"></path><path fill=\"rgb(7,7,7)\" stroke=\"rgb(7,7,7)\" stroke-width=\"1\" opacity=\"1\" d=\"M 25.5 22 L 28 22.5 L 24.5 24 L 25.5 22 Z \"></path><path fill=\"rgb(7,7,7)\" stroke=\"rgb(7,7,7)\" stroke-width=\"1\" opacity=\"1\" d=\"M 33.5 23 L 32.5 25 L 33.5 23 Z \"></path><path fill=\"rgb(7,7,7)\" stroke=\"rgb(7,7,7)\" stroke-width=\"1\" opacity=\"1\" d=\"M 35.5 27 L 36 30.5 L 30.5 40 L 32 37.5 L 35.5 27 Z \"></path><path fill=\"rgb(7,7,7)\" stroke=\"rgb(7,7,7)\" stroke-width=\"1\" opacity=\"1\" d=\"M 30.5 42 L 29.5 44 L 24.5 45 L 24.5 44 Q 29.1 44.6 30.5 42 Z \"></path><path fill=\"rgb(149,149,149)\" stroke=\"rgb(149,149,149)\" stroke-width=\"1\" opacity=\"1\" d=\"M 44.5 13 L 45.5 15 L 44.5 13 Z \"></path><path fill=\"rgb(149,149,149)\" stroke=\"rgb(149,149,149)\" stroke-width=\"1\" opacity=\"1\" d=\"M 34.5 17 L 42 17.5 L 34.5 18 L 34.5 17 Z \"></path><path fill=\"rgb(149,149,149)\" stroke=\"rgb(149,149,149)\" stroke-width=\"1\" opacity=\"1\" d=\"M 22.5 20 L 24 20.5 L 21.5 22 L 22.5 20 Z \"></path><path fill=\"rgb(149,149,149)\" stroke=\"rgb(149,149,149)\" stroke-width=\"1\" opacity=\"1\" d=\"M 14.5 29 L 15 31.5 L 14 31.5 L 14.5 29 Z \"></path><path fill=\"rgb(149,149,149)\" stroke=\"rgb(149,149,149)\" stroke-width=\"1\" opacity=\"1\" d=\"M 31.5 36 L 30 38.5 L 29.5 40 L 29 38.5 L 31.5 36 Z \"></path><path fill=\"rgb(12,12,12)\" stroke=\"rgb(12,12,12)\" stroke-width=\"1\" opacity=\"1\" d=\"M 0 0 L 55 0 L 55 55 L 0 55 L 0 0 Z M 19 10 L 17 11 L 12 17 Q 11 25 14 30 L 13 37 L 25 45 Q 30 46 31 43 L 30 39 Q 31 36 33 38 L 35 34 L 34 31 L 36 31 L 35 27 L 36 24 L 35 20 L 44 19 L 46 22 L 48 21 L 50 22 L 48 19 Q 47 16 50 17 L 51 18 L 48 12 L 45 11 L 43 14 L 44 15 L 43 14 L 32 14 Q 28 9 19 10 Z \"></path><path fill=\"rgb(12,12,12)\" stroke=\"rgb(12,12,12)\" stroke-width=\"1\" opacity=\"1\" d=\"M 20.5 13 L 25 16.5 L 21.5 21 L 17 17.5 Q 20.1 15.7 18.5 14 L 20 14.5 L 20.5 13 Z \"></path><path fill=\"rgb(12,12,12)\" stroke=\"rgb(12,12,12)\" stroke-width=\"1\" opacity=\"1\" d=\"M 26 23 L 29 23.5 L 26.5 25 L 26 23 Z \"></path><path fill=\"rgb(12,12,12)\" stroke=\"rgb(12,12,12)\" stroke-width=\"1\" opacity=\"1\" d=\"M 30.5 32 L 32 32.5 L 29.5 34 L 30.5 32 Z \"></path><path fill=\"rgb(58,58,58)\" stroke=\"rgb(58,58,58)\" stroke-width=\"1\" opacity=\"1\" d=\"M 15.5 12 L 14.5 14 L 15.5 12 Z \"></path><path fill=\"rgb(58,58,58)\" stroke=\"rgb(58,58,58)\" stroke-width=\"1\" opacity=\"1\" d=\"M 29.5 12 L 30.5 14 L 29.5 12 Z \"></path><path fill=\"rgb(58,58,58)\" stroke=\"rgb(58,58,58)\" stroke-width=\"1\" opacity=\"1\" d=\"M 23.5 14 L 24.5 16 L 23.5 14 Z \"></path><path fill=\"rgb(58,58,58)\" stroke=\"rgb(58,58,58)\" stroke-width=\"1\" opacity=\"1\" d=\"M 44.5 15 L 45 17 L 49 19.5 L 48.5 21 L 47.5 19 L 46 19.5 L 46.5 18 L 44.5 19 L 44 16.5 L 44.5 15 Z \"></path><path fill=\"rgb(58,58,58)\" stroke=\"rgb(58,58,58)\" stroke-width=\"1\" opacity=\"1\" d=\"M 16.5 17 L 17.5 19 L 16.5 17 Z \"></path><path fill=\"rgb(58,58,58)\" stroke=\"rgb(58,58,58)\" stroke-width=\"1\" opacity=\"1\" d=\"M 24.5 18 L 23.5 20 L 24.5 18 Z \"></path><path fill=\"rgb(58,58,58)\" stroke=\"rgb(58,58,58)\" stroke-width=\"1\" opacity=\"1\" d=\"M 31.5 31 L 34 32.5 L 32.5 33 L 31.5 31 Z \"></path><path fill=\"rgb(58,58,58)\" stroke=\"rgb(58,58,58)\" stroke-width=\"1\" opacity=\"1\" d=\"M 27.5 32 L 28.5 34 L 27.5 32 Z \"></path><path fill=\"rgb(58,58,58)\" stroke=\"rgb(58,58,58)\" stroke-width=\"1\" opacity=\"1\" d=\"M 13.5 36 L 16.5 40 L 13.5 36 Z \"></path><path fill=\"rgb(167,167,167)\" stroke=\"rgb(167,167,167)\" stroke-width=\"1\" opacity=\"1\" d=\"M 18.5 11 L 25.5 11 L 31.5 15 L 42.5 15 L 44 16.5 L 34 17 L 35 21.5 L 32 23.5 L 32 26 L 34 26.5 L 34 31 L 27 31 L 27 34 L 30.5 35 L 32 34.5 L 29 39.5 L 30 42 Q 27.9 43.6 22.5 43 L 14 36.5 L 15 29.5 Q 11.9 25.1 13 16.5 L 15.5 13 L 18.5 11 Z M 21 12 L 16 14 L 15 18 L 18 20 Q 17 22 21 21 L 23 21 L 26 19 L 26 17 Q 27 14 24 15 L 24 13 L 21 12 Z M 26 21 L 24 25 L 27 26 L 29 25 L 30 22 L 26 21 Z \"></path><path fill=\"rgb(167,167,167)\" stroke=\"rgb(167,167,167)\" stroke-width=\"1\" opacity=\"1\" d=\"M 47.5 16 L 50 16.5 L 47.5 17 L 47.5 16 Z \"></path><path fill=\"rgb(167,167,167)\" stroke=\"rgb(167,167,167)\" stroke-width=\"1\" opacity=\"1\" d=\"M 46.5 18 L 47.5 20 L 46.5 18 Z \"></path><path fill=\"rgb(103,103,103)\" stroke=\"rgb(103,103,103)\" stroke-width=\"1\" opacity=\"1\" d=\"M 20.5 10 L 24 10.5 L 20.5 11 L 20.5 10 Z \"></path><path fill=\"rgb(103,103,103)\" stroke=\"rgb(103,103,103)\" stroke-width=\"1\" opacity=\"1\" d=\"M 18.5 13 L 17.5 15 L 16 14.5 L 18.5 13 Z \"></path><path fill=\"rgb(103,103,103)\" stroke=\"rgb(103,103,103)\" stroke-width=\"1\" opacity=\"1\" d=\"M 45.5 13 L 49 15.5 L 46.5 17 L 45.5 13 Z \"></path><path fill=\"rgb(103,103,103)\" stroke=\"rgb(103,103,103)\" stroke-width=\"1\" opacity=\"1\" d=\"M 31.5 14 L 42 14.5 L 31.5 15 L 31.5 14 Z \"></path><path fill=\"rgb(103,103,103)\" stroke=\"rgb(103,103,103)\" stroke-width=\"1\" opacity=\"1\" d=\"M 12.5 18 L 13 21.5 L 12 21.5 L 12.5 18 Z \"></path><path fill=\"rgb(103,103,103)\" stroke=\"rgb(103,103,103)\" stroke-width=\"1\" opacity=\"1\" d=\"M 29.5 23 L 28.5 25 L 29.5 23 Z \"></path><path fill=\"rgb(103,103,103)\" stroke=\"rgb(103,103,103)\" stroke-width=\"1\" opacity=\"1\" d=\"M 24.5 43 L 27 43.5 L 24.5 44 L 24.5 43 Z \"></path><path fill=\"rgb(26,26,26)\" stroke=\"rgb(26,26,26)\" stroke-width=\"1\" opacity=\"1\" d=\"M 44.5 11 Q 46.8 10.3 46 12.5 L 44.5 11 Z \"></path><path fill=\"rgb(26,26,26)\" stroke=\"rgb(26,26,26)\" stroke-width=\"1\" opacity=\"1\" d=\"M 30.5 40 L 31 41.5 L 29 42.5 L 30.5 40 Z \"></path></svg>", 25, 25)
local misc_svg = renderer.load_svg("<svg width=\"68\" height=\"61\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\"><path fill=\"rgb(46,46,46)\" stroke=\"rgb(46,46,46)\" stroke-width=\"1\" opacity=\"1\" d=\"M 43.5 10 L 42.5 12 L 43.5 10 Z \"></path><path fill=\"rgb(46,46,46)\" stroke=\"rgb(46,46,46)\" stroke-width=\"1\" opacity=\"1\" d=\"M 45.5 10 L 47.5 13 L 45.5 10 Z \"></path><path fill=\"rgb(46,46,46)\" stroke=\"rgb(46,46,46)\" stroke-width=\"1\" opacity=\"1\" d=\"M 46.5 15 L 49 15.5 L 45.5 17 L 46.5 15 Z \"></path><path fill=\"rgb(46,46,46)\" stroke=\"rgb(46,46,46)\" stroke-width=\"1\" opacity=\"1\" d=\"M 21.5 18 L 24 19.5 L 22.5 20 L 21.5 18 Z \"></path><path fill=\"rgb(46,46,46)\" stroke=\"rgb(46,46,46)\" stroke-width=\"1\" opacity=\"1\" d=\"M 34.5 18 L 33.5 20 L 32 19.5 L 34.5 18 Z \"></path><path fill=\"rgb(46,46,46)\" stroke=\"rgb(46,46,46)\" stroke-width=\"1\" opacity=\"1\" d=\"M 45.5 19 L 49 20.5 L 46.5 21 L 45.5 19 Z \"></path><path fill=\"rgb(46,46,46)\" stroke=\"rgb(46,46,46)\" stroke-width=\"1\" opacity=\"1\" d=\"M 53.5 20 L 53 21.5 L 52.5 23 L 52 21.5 L 53.5 20 Z \"></path><path fill=\"rgb(46,46,46)\" stroke=\"rgb(46,46,46)\" stroke-width=\"1\" opacity=\"1\" d=\"M 40.5 26 L 43 27.5 L 42.5 29 L 42 27 L 40.5 26 Z \"></path><path fill=\"rgb(46,46,46)\" stroke=\"rgb(46,46,46)\" stroke-width=\"1\" opacity=\"1\" d=\"M 33.5 27 L 34 30.5 L 33 30.5 L 33.5 27 Z \"></path><path fill=\"rgb(46,46,46)\" stroke=\"rgb(46,46,46)\" stroke-width=\"1\" opacity=\"1\" d=\"M 22.5 28 L 23 30.5 L 22 30.5 L 22.5 28 Z \"></path><path fill=\"rgb(46,46,46)\" stroke=\"rgb(46,46,46)\" stroke-width=\"1\" opacity=\"1\" d=\"M 16.5 32 L 19 33.5 L 17 37.5 L 19.5 41 L 16 36.5 L 18 33 L 16.5 32 Z \"></path><path fill=\"rgb(46,46,46)\" stroke=\"rgb(46,46,46)\" stroke-width=\"1\" opacity=\"1\" d=\"M 23.5 32 L 24.5 34 L 23.5 32 Z \"></path><path fill=\"rgb(46,46,46)\" stroke=\"rgb(46,46,46)\" stroke-width=\"1\" opacity=\"1\" d=\"M 32.5 32 L 31.5 34 L 32.5 32 Z \"></path><path fill=\"rgb(46,46,46)\" stroke=\"rgb(46,46,46)\" stroke-width=\"1\" opacity=\"1\" d=\"M 38.5 32 L 41 32.5 L 38.5 33 L 38.5 32 Z \"></path><path fill=\"rgb(46,46,46)\" stroke=\"rgb(46,46,46)\" stroke-width=\"1\" opacity=\"1\" d=\"M 50.5 32 L 48.5 35 L 50.5 32 Z \"></path><path fill=\"rgb(46,46,46)\" stroke=\"rgb(46,46,46)\" stroke-width=\"1\" opacity=\"1\" d=\"M 52.5 33 L 53.5 35 L 52.5 33 Z \"></path><path fill=\"rgb(46,46,46)\" stroke=\"rgb(46,46,46)\" stroke-width=\"1\" opacity=\"1\" d=\"M 38.5 35 L 40 38 L 42 38.5 L 39.5 40 L 39 37.5 L 38.5 35 Z \"></path><path fill=\"rgb(46,46,46)\" stroke=\"rgb(46,46,46)\" stroke-width=\"1\" opacity=\"1\" d=\"M 52.5 36 L 53 38 L 56 38.5 L 53.5 39 L 52.5 36 Z \"></path><path fill=\"rgb(46,46,46)\" stroke=\"rgb(46,46,46)\" stroke-width=\"1\" opacity=\"1\" d=\"M 25.5 43 L 31 43.5 L 25.5 44 L 25.5 43 Z \"></path><path fill=\"rgb(46,46,46)\" stroke=\"rgb(46,46,46)\" stroke-width=\"1\" opacity=\"1\" d=\"M 48.5 46 L 49.5 48 L 48.5 46 Z \"></path><path fill=\"rgb(46,46,46)\" stroke=\"rgb(46,46,46)\" stroke-width=\"1\" opacity=\"1\" d=\"M 53.5 46 L 52.5 48 L 53.5 46 Z \"></path><path fill=\"rgb(12,12,12)\" stroke=\"rgb(12,12,12)\" stroke-width=\"1\" opacity=\"1\" d=\"M 0 0 L 68 0 L 68 61 L 0 61 L 0 0 Z M 44 10 L 42 12 L 43 15 L 39 16 L 39 20 L 41 20 Q 43 21 42 25 L 46 27 L 49 25 L 52 27 L 55 26 L 53 24 Q 56 22 54 21 L 56 21 Q 58 22 57 18 L 54 16 L 55 14 L 54 11 L 52 10 L 49 12 L 44 10 Z M 25 15 L 25 19 L 20 18 L 16 22 L 18 24 Q 19 28 14 26 L 14 32 L 18 35 L 16 38 L 22 42 L 21 41 L 23 41 L 25 40 L 25 44 L 32 45 L 31 41 L 33 41 L 33 40 L 37 42 L 39 41 L 39 43 L 43 45 L 42 48 Q 43 50 47 49 L 48 46 Q 48 50 54 49 L 53 46 L 55 44 Q 59 45 57 40 L 54 38 L 55 36 L 52 33 L 51 32 L 48 35 L 46 32 L 44 33 L 42 30 L 43 28 L 39 26 L 40 24 L 40 22 L 38 18 L 31 19 L 32 17 Q 30 13 25 15 Z \"></path><path fill=\"rgb(12,12,12)\" stroke=\"rgb(12,12,12)\" stroke-width=\"1\" opacity=\"1\" d=\"M 49.5 16 L 50 20 L 46 20 L 46 18.5 L 49.5 16 Z \"></path><path fill=\"rgb(12,12,12)\" stroke=\"rgb(12,12,12)\" stroke-width=\"1\" opacity=\"1\" d=\"M 24.5 25 L 26.5 26 L 30.5 25 L 33 26 Q 34.5 32.3 30.5 34 L 27.5 35 L 24 32.5 L 25 26.5 L 24.5 25 Z \"></path><path fill=\"rgb(12,12,12)\" stroke=\"rgb(12,12,12)\" stroke-width=\"1\" opacity=\"1\" d=\"M 39 34 Q 42.8 32.5 42 35.5 L 43 38 L 39 35.5 L 39 34 Z \"></path><path fill=\"rgb(12,12,12)\" stroke=\"rgb(12,12,12)\" stroke-width=\"1\" opacity=\"1\" d=\"M 46.5 38 L 50 39 L 48.5 43 L 45 41.5 L 46.5 38 Z \"></path><path fill=\"rgb(5,5,5)\" stroke=\"rgb(5,5,5)\" stroke-width=\"1\" opacity=\"1\" d=\"M 46.5 16 L 48 16.5 L 46 17 L 45.5 19 L 45 17.5 L 46.5 16 Z \"></path><path fill=\"rgb(5,5,5)\" stroke=\"rgb(5,5,5)\" stroke-width=\"1\" opacity=\"1\" d=\"M 56.5 17 L 57 21 L 55 20.5 L 56.5 17 Z \"></path><path fill=\"rgb(5,5,5)\" stroke=\"rgb(5,5,5)\" stroke-width=\"1\" opacity=\"1\" d=\"M 40.5 22 L 38.5 25 L 40.5 22 Z \"></path><path fill=\"rgb(5,5,5)\" stroke=\"rgb(5,5,5)\" stroke-width=\"1\" opacity=\"1\" d=\"M 26.5 24 L 30 24.5 Q 25.3 24.3 24 27.5 L 23.5 30 L 23 27.5 L 26.5 24 Z \"></path><path fill=\"rgb(5,5,5)\" stroke=\"rgb(5,5,5)\" stroke-width=\"1\" opacity=\"1\" d=\"M 47.5 24 L 47 25.5 Q 47.8 27.8 45.5 27 L 47.5 24 Z \"></path><path fill=\"rgb(5,5,5)\" stroke=\"rgb(5,5,5)\" stroke-width=\"1\" opacity=\"1\" d=\"M 53.5 25 L 52.5 27 L 51 26.5 L 53.5 25 Z \"></path><path fill=\"rgb(5,5,5)\" stroke=\"rgb(5,5,5)\" stroke-width=\"1\" opacity=\"1\" d=\"M 38 33 L 40 33.5 L 38 34.5 L 38 33 Z \"></path><path fill=\"rgb(5,5,5)\" stroke=\"rgb(5,5,5)\" stroke-width=\"1\" opacity=\"1\" d=\"M 47.5 38 L 49 38.5 L 45.5 41 L 47.5 38 Z \"></path><path fill=\"rgb(5,5,5)\" stroke=\"rgb(5,5,5)\" stroke-width=\"1\" opacity=\"1\" d=\"M 23.5 39 L 21.5 42 L 20 41.5 L 23.5 39 Z \"></path><path fill=\"rgb(5,5,5)\" stroke=\"rgb(5,5,5)\" stroke-width=\"1\" opacity=\"1\" d=\"M 38.5 39 L 39 40.5 L 36.5 42 L 38.5 39 Z \"></path><path fill=\"rgb(5,5,5)\" stroke=\"rgb(5,5,5)\" stroke-width=\"1\" opacity=\"1\" d=\"M 56.5 40 L 57 42.5 L 53.5 44 L 53.5 43 Q 57.5 44.1 56.5 40 Z \"></path><path fill=\"rgb(5,5,5)\" stroke=\"rgb(5,5,5)\" stroke-width=\"1\" opacity=\"1\" d=\"M 46.5 47 L 48 47.5 L 44.5 49 L 44.5 48 L 46.5 47 Z \"></path><path fill=\"rgb(5,5,5)\" stroke=\"rgb(5,5,5)\" stroke-width=\"1\" opacity=\"1\" d=\"M 50.5 48 L 53 48.5 L 50.5 49 L 50.5 48 Z \"></path><path fill=\"rgb(10,10,10)\" stroke=\"rgb(10,10,10)\" stroke-width=\"1\" opacity=\"1\" d=\"M 54.5 21 L 53.5 23 L 54.5 21 Z \"></path><path fill=\"rgb(10,10,10)\" stroke=\"rgb(10,10,10)\" stroke-width=\"1\" opacity=\"1\" d=\"M 39.5 24 L 38.5 26 L 39.5 24 Z \"></path><path fill=\"rgb(10,10,10)\" stroke=\"rgb(10,10,10)\" stroke-width=\"1\" opacity=\"1\" d=\"M 48.5 24 L 47.5 26 L 48.5 24 Z \"></path><path fill=\"rgb(10,10,10)\" stroke=\"rgb(10,10,10)\" stroke-width=\"1\" opacity=\"1\" d=\"M 41.5 32 L 42 34 L 40 33.5 L 41.5 32 Z \"></path><path fill=\"rgb(10,10,10)\" stroke=\"rgb(10,10,10)\" stroke-width=\"1\" opacity=\"1\" d=\"M 27.5 44 L 32 44.5 L 27.5 45 L 27.5 44 Z \"></path><path fill=\"rgb(10,10,10)\" stroke=\"rgb(10,10,10)\" stroke-width=\"1\" opacity=\"1\" d=\"M 54.5 47 L 53.5 49 L 54.5 47 Z \"></path><path fill=\"rgb(158,158,158)\" stroke=\"rgb(158,158,158)\" stroke-width=\"1\" opacity=\"1\" d=\"M 44.5 10 L 47.5 13 L 50.5 10 L 51.5 11 Q 54.1 10.2 53 13.5 L 52 16 Q 58 14 56 20 L 52 21.5 L 53 25 L 50.5 26 Q 49.4 23.3 46 24 Q 47.1 26.7 44.5 26 L 42 25 L 43 20 L 39 18.5 L 40.5 16 Q 44.3 17.3 43 13.5 Q 40.3 11.8 44.5 10 Z M 47 15 Q 44 16 45 20 L 49 21 L 51 18 Q 51 15 47 15 Z \"></path><path fill=\"rgb(158,158,158)\" stroke=\"rgb(158,158,158)\" stroke-width=\"1\" opacity=\"1\" d=\"M 26.5 15 Q 30.3 14.3 31 16.5 L 32.5 20 L 36.5 18 Q 39.5 18.5 39 22.5 L 38 26 L 42 27 L 42 32 Q 36.4 29.8 38 35.5 L 39 38.5 L 35.5 41 Q 34.4 38.3 31 39 L 31 43 L 25 43 Q 27.1 37.8 22.5 39 L 20.5 41 L 17 37.5 L 19 33.5 Q 17.8 31 14 32 L 14 27 L 15.5 27 L 19 24.5 L 17 20.5 L 20.5 18 L 23.5 20 L 26.5 15 Z M 26 24 L 22 29 L 23 33 L 27 35 L 32 34 Q 35 33 34 28 Q 33 23 26 24 Z \"></path><path fill=\"rgb(158,158,158)\" stroke=\"rgb(158,158,158)\" stroke-width=\"1\" opacity=\"1\" d=\"M 43.5 33 L 48.5 35 L 51.5 33 L 53 35.5 L 52 37.5 L 56 39 Q 57.5 42.8 54.5 42 L 52 43 L 53 46.5 L 50.5 48 L 47.5 46 L 43.5 48 Q 40.8 46.8 43 45.5 Q 44.1 42.2 41.5 43 L 39 42 L 40.5 39 L 43 37.5 L 42 34.5 L 43.5 33 Z M 47 38 L 45 40 L 47 43 Q 51 44 50 42 L 50 40 Q 51 36 47 38 Z \"></path></svg>",0,0)

-- region framework

local surface = require("gamesense/surface");
local easing = require("gamesense/easing");

local KEYS = {
    [0x30] = "0", [0x31] = "1", [0x32] = "2", [0x33] = "3", [0x34] = "4", [0x35] = "5", [0x36] = "6", [0x37] = "7", [0x38] = "8", [0x39] = "9",
    [0x41] = "a", [0x42] = "b", [0x43] = "c", [0x44] = "d", [0x45] = "e", [0x46] = "f", [0x47] = "g", [0x48] = "h", [0x49] = "i", [0x4A] = "j", [0x4B] = "k", [0x4C] = "l", [0x4D] = "m", [0x4E] = "n", [0x4F] = "o", [0x50] = "p", [0x51] = "q", [0x52] = "r", [0x53] = "s", [0x54] = "t", [0x55] = "u", [0x56] = "v", [0x57] = "w", [0x58] = "x", [0x59] = "y", [0x5A] = "z", 
    [0xBA] = ";", [0xBB] = "=", [0xBC] = ",", [0xBD] = "-", [0xBE] = ".", [0xBF] = "/",
    [0xDB] = "[", [0xDC] = "\\", [0xDD] = "]", [0xDE] = "\'",
    [0x20] = " ", [0x08] = "BACKSPACE", [0xE8] = "-", [0x01] = "M1", [0x02] = "M2", [0x04] = "M3", [0x05] = "M4", [0x06] = "M5", [0x1B] = "ESC"
}

local keyStates = {};

local function intersects(x, y, w, h)
    local mx, my = surface.get_mouse_pos();
    return (mx > x and mx < x + w and my > y and my < y + h);
end

local function clamp(x, min, max)
    if min ~= nil and max ~= nil and x ~= nil then
        return x < min and min or x > max and max or x;
    end
end

local function includes(tab, val)
    for i = 1, #tab do
        if tab[i] == val then
            return true
        end
    end

    return false
end

local function removeSelected(tab, val)
    for i = 1, #tab do
        if tab[i] == val then
            table.remove(tab, i)
        end
    end
end

local function unClick(key)
	if keyStates[key] == nil then
		keyStates[key] = false;
	end

	if client.key_state(key) then
		keyStates[key] = true;
	end

	if not client.key_state(key) and keyStates[key] then
		keyStates[key] = false;
		return true;
	end

	return false;
end

local function onIntersectPress(x, y, w, h, callback)
	if intersects(x, y, w, h) and client.key_state(0x01) then
		callback();
	end
end

local function onIntersectRelease(x, y, w, h, callback)
	if intersects(x, y, w, h) and unClick(0x01) then
		callback();
	end
end

local function rgbToHsv(r, g, b, a)
    r, g, b, a = r / 255, g / 255, b / 255, a / 255;
    local max, min = math.max(r, g, b), math.min(r, g, b);
    local h, s, v;
    v = max;
  
    local d = max - min;
    if max == 0 then s = 0; else s = d / max; end
  
    if max == min then
        h = 0; -- achromatic
    else
        if max == r then
        h = (g - b) / d;
        if g < b then h = h + 6; end
        elseif max == g then h = (b - r) / d + 2;
        elseif max == b then h = (r - g) / d + 4;
        end
        h = h / 6;
    end
  
    return h, s, v, a;
end

local function hsvToRgb(h, s, v, a)
    local r, g, b;

    local i = math.floor(h * 6);
    local f = h * 6 - i;
    local p = v * (1 - s);
    local q = v * (1 - f * s);
    local t = v * (1 - (1 - f) * s);

    i = i % 6;

    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p;
    elseif i == 2 then r, g, b = p, v, t;
    elseif i == 3 then r, g, b = p, q, v;
    elseif i == 4 then r, g, b = t, p, v;
    elseif i == 5 then r, g, b = v, p, q;
    end

    return r * 255, g * 255, b * 255, a * 255;
end

local function newElement(id, tab, subtab, name)
	return {
		id = id,
		tab = tab,
		subtab = subtab,
		name = name,
		visible = true,
		ofstVisible = true,
		callback = nil,
		offset = 0,
		colorpickers = 0,
		alpha = 1
	}
end

local Framework = {};

function Framework.new(title)
	local self = {};

	local m = {
		x = 705,
		moveX = 0,
		y = 5,
		moveY = 0,
		minWidth = 500,
		width = 500,
		minHeight = 400,
		height = 400,
		title = title or "LUA Menu",
		visible = true,
		extendedTabs = false,
		extendedTabsValue = 0,
		font = surface.create_font("Segoe UI", 15, 800, {0x010}),
		accent = {235, 97, 35},
		padding = 12, -- dont touch or drone strike
		dragging = false,
		scrolling = false,
		yofst = 0,
		tabs = {},
		elements = {},
		currentTab = nil,
		inSwitch = nil
	};

  function self.newTab(name,passed_image)
    m.tabs[#m.tabs + 1] = {
        name = name,
        subtabs = {},
        currentSubtab = nil,
        image = passed_image
    }
end
	function self.newSubtab(tab, name)
		for _, v in ipairs(m.tabs) do
			if v.name == tab then
				v.subtabs[#v.subtabs + 1] = name;
			end
		end
	end

	function self.newCheckbox(tab, subtab, name)
		local id = #m.elements + 1;

		local element = newElement(id, tab, subtab, name);
		element.type = "checkbox";
		element.value = false;
		element.defaultValue = false;
		element.height = 16

		m.elements[id] = element;

		return id;
	end

	function self.newSlider(tab, subtab, name, min, max, init)
		local id = #m.elements + 1;

		local element = newElement(id, tab, subtab, name);
		element.type = "slider";
		element.value = init;
		element.defaultValue = init;
		element.min = min;
		element.max = max;
		element.height = 28 + m.padding;

		m.elements[id] = element;

		return id;
	end

	function self.newCombobox(tab, subtab, name, ...)
		local options = {...};

		if type(options[1]) == "table" then
			options = options[1];
		end

		local id = #m.elements + 1;

		local element = newElement(id, tab, subtab, name);
		element.type = "combobox";
		element.value = options[1];
		element.defaultValue = options[1];
		element.collapsed = true;
		element.options = options;
		element.height = 40 + m.padding;

		m.elements[id] = element;

		return id;
	end

	function self.newMultiselect(tab, subtab, name, ...)
		local options = {...};

		if type(options[1]) == "table" then
			options = options[1];
		end

		local id = #m.elements + 1;

		local element = newElement(id, tab, subtab, name);
		element.type = "multiselect";
		element.value = {options[1]};
		element.defaultValue = {options[1]};
		element.collapsed = true;
		element.options = options;
		element.height = 40 + m.padding;

		m.elements[id] = element;

		return id;
	end

	function self.newColorPicker(tab, subtab, name, ...)
		local args = {...};

		if type(args[1]) == "table" then
			args = args[1];
		end

		local h, s, v = rgbToHsv(args[1], args[2], args[3], args[4] or 255);

		local id = #m.elements + 1;

		local element = newElement(id, tab, subtab, name);

		element.type = "colorpicker";
		element.value = {args[1], args[2], args[3], args[4] or 255};
		element.defaultValue = {args[1], args[2], args[3], args[4] or 255};
		element.h = h;
		element.s = s;
		element.v = v;
		element.collapsed = true;
		element.height = 14;
		element.changeType = nil;

		m.elements[id] = element;

		return id;
	end

	function self.newHotkey(tab, subtab, name)
		local id = #m.elements + 1;

		local element = newElement(id, tab, subtab, name);
		element.type = "hotkey";
		element.key = 0xE8;
		element.state = "holding";
		element.canSwitch = true;
		element.value = false;
		element.height = 14;

		m.elements[id] = element;

		return id;
	end

  function self.reference(tab,subtab,name)
    for i = 1, #m.elements do
        local element = m.elements[i]

        if element.tab == tab and element.subtab == subtab and element.name == name then
            return element.id, element.name
        end
    end

    return nil
end

	function self.get(id)
    if m.elements[id].value == nil then
      print("Error returning value 'nil'")
    end
		return m.elements[id].value;
	end
  
  self.set = function(id, ...)
    if #m.elements == 0 or id == nil then
        return
    end

    local args = {...}

    if type(args[1]) == "table" then
        args = args[1]
    end

    if m.elements[id].type == "checkbox" and type(args[1]) ~= "boolean" then
        client.error_log("Failed to set value: type should be (boolean)")
        return
    elseif m.elements[id].type == "slider" and type(args[1]) ~= "number" then
        client.error_log("Failed to set value: type should be (number) or value is out of bounds")
        return
    elseif m.elements[id].type == "combobox" and not includes(m.elements[id].options, args[1]) then
        --client_error_log("Failed to set value: value not found in options".. elements[id].name)
        return
    elseif m.elements[id].type == "multiselect" then
        for i = 1, #args do
            if not includes(m.elements[id].options, args[i]) then
                client.error_log("Failed to set value: value not found in options" .. m.elements[id].name)
                return
            end
        end 
    elseif m.elements[id].type == "textbox" and type(args[1]) ~= "string" then
        client.error_log("Failed to set value: type should be (string)")
        return
    elseif m.elements[id].type == "label" and type(args[1]) ~= "string" then
        client.error_log("Failed to set value: type should be (string)")
        return
    elseif m.elements[id].type == "button" and type(args[1]) ~= "boolean" then
        client.error_log("Failed to set value: type should be (boolean)")
        return
    elseif m.elements[id].type == "colorpicker" then
        for i = 1, #args do
            if type(args[i]) ~= "number" or args[i] > 255 or args[i] < 0 then
                client.error_log("Failed to set value: type should be (number) or value is out of bounds")
                return
            end
        end
    end

    if m.elements[id].type == "slider" then
        m.elements[id].value = math.max(m.elements[id].min, math.min(m.elements[id].max, args[1]))
    elseif m.elements[id].type == "multiselect" or m.elements[id].type == "colorpicker" then
        m.elements[id].value = args
    elseif m.elements[id].type == "label" then
        m.elements[id].name = args[1]
        m.elements[id].value = args[1]
    else
        m.elements[id].value = args[1]
    end
end

	function self.reset(id)
		m.elements[id].value = m.elements[id].defaultValue;
	end

	function self.setVisible(id, bool)
		m.elements[id].visible = bool or true;	
	end
  
  function self.save_settings(name)
    local temp_table = {}

    for i = 1, #m.elements do
        local element = m.elements[i]

        temp_table[#temp_table + 1] = {element.tab, element.subtab, element.name, element.value}
    end

    database.write(string.format("framework.settings.%s", name), temp_table)
  end

  function self.load_settings(name)
    local settings = database.read(string.format("framework.settings.%s", name)) or {}

    for i = 1, #settings do
        local setting = settings[i]
        local reference = self.reference(setting[1], setting[2], setting[3])
        self.set(reference, setting[4])
    end
  end

-- #e
	function self.draw()
		if ui.is_menu_open() then
			local leftClick = client.key_state(0x01);
			local mx, my = surface.get_mouse_pos();
		
			-- region movement
			if m.dragging then
				m.x = mx - m.moveX;
				m.y = my - m.moveY;
		
				if not leftClick then
					m.dragging = false;
				end
			end
		
			onIntersectPress(m.x, m.y, m.width, 25, function()
				if not m.extendedTabs then
					m.dragging = true;
					m.moveX = mx - m.x;
					m.moveY = my - m.y;
				end
			end)
			-- endregion
		
			surface.draw_filled_outlined_rect(m.x, m.y, m.width, m.height, 25, 25, 25, 255, 120, 120, 120, 255); -- menu body

			-- region elements
			local ofst = m.padding;
			local visofst = m.padding;
			local scrollbarHeight = 0;

			if m.scrolling then
				m.yofst = clamp(my - m.y + 54, 0, m.y + m.height);

				if not client.key_state(0x01) then
					m.scrolling = false;
				end
			end

			--[[onIntersectPress(m.x + m.width - 7, m.y + 53, 4, (m.height - 81) * clamp(visofst / ofst, 0, 1), function()
				m.scrolling = true;
			end)]]

			for layer = 1, 2 do
				for gamerrino, v in ipairs(m.elements) do
					if layer == 1 then
						if v.tab == m.currentTab and v.subtab == m.currentSubtab and v.visible then
							local tw, th = surface.get_text_size(m.font, v.name);

							local x = m.x + 37 + m.padding;
							local y = m.y + 54 + ofst - m.yofst;

							v.ofstVisible = y < m.y + m.height - 25 and y > m.y + 27;

							if v.ofstVisible then
								v.offset = ofst;

								if v.type == "checkbox" then
									local checkboxAnim = easing.sine_in(v.alpha, 0, 1, 1)

									surface.draw_filled_outlined_rect(x, y, 16, 16, 40, 40, 40, 255, 80, 80, 80, 255);
									surface.draw_text(x + 16 + m.padding, y, 255, 255, 255, 255, m.font, v.name);

									if not m.extendedTabs and m.inSwitch == nil then
										onIntersectRelease(x, y, 16 + m.padding + tw, 16, function()
											v.value = not v.value;
										end)
									end

									v.alpha = clamp(v.alpha + (v.value and globals.frametime() * 10 or globals.frametime() * -10), 0, 1);

									surface.draw_text(x + 1, y, m.accent[1], m.accent[2], m.accent[3], 255 * checkboxAnim, m.font, "✔");
								elseif v.type == "slider" then
									surface.draw_text(x + m.padding, y, 255, 255, 255, 255, m.font, v.name.. " ( ".. v.value.. " )");

									surface.draw_filled_outlined_rect(x + m.padding, y + th + m.padding, m.width - 100, 12, 40, 40, 40, 255, 80, 80, 80, 255);
									surface.draw_filled_outlined_rect(x + m.padding, y + th + m.padding, (m.width - 100) * math.abs(v.value - v.min) / (v.max - v.min), 12, m.accent[1], m.accent[2], m.accent[3], 255, 80, 80, 80, 255);

									if m.inSwitch == v.id then
										v.value = math.max(v.min, math.min(v.max, (math.floor((mx - x - m.padding) / (m.width - 102) * (v.max - v.min) + v.min + 0.5))));

										if not client.key_state(0x01) then
											m.inSwitch = nil;
										end
									end

									if not m.extendedTabs then
										onIntersectPress(x, y + th + m.padding, m.width - 100, 12, function()
											m.inSwitch = m.inSwitch == nil and v.id or m.inSwitch;
										end)
									end
								elseif v.type == "combobox" then
									surface.draw_text(x + m.padding, y, 255, 255, 255, 255, m.font, v.name);
									surface.draw_filled_outlined_rect(x + m.padding, y + th + m.padding, m.width - 100, 24, 40, 40, 40, 255, 80, 80, 80, 255);
									surface.draw_text(x + m.padding * 2, y + th + m.padding + 4, 255, 255, 255, 255, m.font, v.value);

									if not m.extendedTabs and v.collapsed and m.inSwitch == nil then
										onIntersectRelease(x + m.padding, y + th + m.padding, m.width - 100, 24, function()
											v.collapsed = false;
											m.inSwitch = m.inSwitch == nil and v.id or m.inSwitch;
										end)
									end
								elseif v.type == "multiselect" then
									surface.draw_text(x + m.padding, y, 255, 255, 255, 255, m.font, v.name);
									surface.draw_filled_outlined_rect(x + m.padding, y + th + m.padding, m.width - 100, 24, 40, 40, 40, 255, 80, 80, 80, 255);

									local str = "";

									for i, val in pairs(v.value) do
										str = str.. val.. ", ";
									end

									str = string.sub(str, 1, string.len(str) - 2)

									surface.draw_text(x + m.padding * 2, y + th + m.padding + 4, 255, 255, 255, 255, m.font, str);

									if not m.extendedTabs and v.collapsed and m.inSwitch == nil then
										onIntersectRelease(x + m.padding, y + th + m.padding, m.width - 100, 24, function()
											v.collapsed = false;
											m.inSwitch = m.inSwitch == nil and v.id or m.inSwitch;
										end)
									end
								elseif v.type == "colorpicker" then
									surface.draw_filled_outlined_rect(x, y, 16, 16, v.value[1], v.value[2], v.value[3], v.value[4], 80, 80, 80, 255);
									surface.draw_text(x + 16 + m.padding, y, 255, 255, 255, 255, m.font, v.name);

									if not m.extendedTabs and m.inSwitch == nil then
										onIntersectRelease(x, y, 16 + m.padding + tw, 16, function()
											if v.collapsed then
												v.collapsed = false;
											end
										end)
									end

									if not v.collapsed then
										m.inSwitch = v.id;
									end
								elseif v.type == "hotkey" then
                  if m.inSwitch ~= v.id then
									  surface.draw_text(x + 16 + m.padding, y, 255, 255, 255, 255, m.font, v.name.. " ( ".. (KEYS[v.key] or "").. " )");
                  end

									onIntersectRelease(x + 16 + m.padding, y, tw + surface.get_text_size(m.font, " ( ".. (KEYS[v.key] or "").. " )"), th, function()
										m.inSwitch = m.inSwitch == nil and v.id or m.inSwitch;
									end)

									if m.inSwitch == v.id then
                    surface.draw_text(x + 16 + m.padding, y, 235, 97, 35, 255, m.font, v.name.. " ( ".. (KEYS[v.key] or "").. " )");
										for k, spritesoda in pairs(KEYS) do
											if unClick(k) then
												if spritesoda == "BACKSPACE" then k = 0xE8 else v.key = k end
												client.delay_call(0, function() m.inSwitch = nil end)
											end
										end
									end

									if v.state == "always on" then
										v.value = true;
									elseif v.state == "holding" then
										v.value = client.key_state(v.key);
									elseif v.state == "off hotkey" then
										v.value = not client.key_state(v.key);
									elseif v.state == "toggle" then
										if v.canSwitch then
											v.value = not v.value;
											v.canSwitch = false;
										end
									end

									if not client.key_state(v.key) and not v.canSwitch then
										v.canSwitch = true;
									end
								end

								visofst = visofst + v.height + m.padding;
							end

							ofst = ofst + v.height + m.padding;
						end
					elseif layer == 2 then
						if v.tab == m.currentTab and v.subtab == m.currentSubtab and v.visible then
							local tw, th = surface.get_text_size(m.font, v.name);

							local x = m.x + 37 + m.padding;
							local y = m.y + 54 + v.offset - m.yofst;

							if v.type == "combobox" then
								if not v.collapsed then
									surface.draw_filled_outlined_rect(x + m.padding, y + th + m.padding * 2 + 24, m.width - 100, 24 * #v.options, 40, 40, 40, 255, 80, 80, 80, 255);

									for i, val in pairs(v.options) do
										local col = val == v.value and m.accent or {255, 255, 255}

										surface.draw_text(x + m.padding * 2, y + th + m.padding * 2 + 4 + 24 * i, col[1], col[2], col[3], 255, m.font, val);

										onIntersectPress(x + m.padding + 1, y + th + m.padding * 2 + 24 * i, m.width - 102, 24, function()
											surface.draw_filled_rect(x + m.padding + 1, y + th + m.padding * 2 + 24 * i, m.width - 102, 24, 200, 200, 200, 50);
										end)
											
										onIntersectRelease(x + m.padding + 1, y + th + m.padding * 2 + 24 * i, m.width - 102, 24, function()
											v.value = val;
											v.collapsed = true;
											m.inSwitch = nil;
										end)
									end

									if unClick(0x01) then
										v.collapsed = true;
										m.inSwitch = nil;
									end
								end
							elseif v.type == "multiselect" then
								if not v.collapsed then
									surface.draw_filled_outlined_rect(x + m.padding, y + th + m.padding * 2 + 24, m.width - 100, 24 * #v.options, 40, 40, 40, 255, 80, 80, 80, 255);
		
									for i, val in pairs(v.options) do
										local col = includes(v.value, val) and m.accent or {255, 255, 255}
		
										surface.draw_text(x + m.padding * 2, y + th + m.padding * 2 + 4 + 24 * i, col[1], col[2], col[3], 255, m.font, val);
		
										onIntersectPress(x + m.padding + 1, y + th + m.padding * 2 + 24 * i, m.width - 102, 24, function()
											surface.draw_filled_rect(x + m.padding + 1, y + th + m.padding * 2 + 24 * i, m.width - 102, 24, 200, 200, 200, 50);
										end)
												
										onIntersectRelease(x + m.padding + 1, y + th + m.padding * 2 + 24 * i, m.width - 102, 24, function()
											if includes(v.value, v.options[i]) then
												removeSelected(v.value, v.options[i])
											else
												v.value[#v.value+1] = v.options[i]
											end
										end)
									end
		
									if unClick(0x01) and not intersects(x + m.padding, y + th + m.padding * 2 + 24, m.width - 100, 24 * #v.options) then
										v.collapsed = true;
										m.inSwitch = nil;
									end
								end
							elseif v.type == "colorpicker" then
								if not v.collapsed then
									if not intersects(x, y + 14 + m.padding, 300, 200) and unClick(0x01) and v.changeType == nil then
										v.collapsed = true;
										v.changeType = nil;
										m.inSwitch = nil;
									end
									
									local temp = {rgbToHsv(v.value[1], v.value[2], v.value[3], 255)};
									temp = {hsvToRgb(temp[1], 1, 1, 1)};
									surface.draw_filled_outlined_rect(x, y + 14 + m.padding, 260, 200, 40, 40, 40, 255, 80, 80, 80, 255);
									surface.draw_filled_gradient_rect(x + m.padding, y + 14 + m.padding * 2, 200 - m.padding * 2, 200 - m.padding * 2, 255, 255, 255, 255, temp[1], temp[2], temp[3], 255, true);
									surface.draw_filled_gradient_rect(x + m.padding, y + 14 + m.padding * 2, 200 - m.padding * 2, 200 - m.padding * 2, 0, 0, 0, 0, 0, 0, 0, 255, false);
									surface.draw_filled_gradient_rect(x + 230, y + 14 + m.padding * 2, 15, 200 - m.padding * 2, 0, 0, 0, 0, v.value[1], v.value[2], v.value[3], 255, false);
									-- math.max(v.min, math.min(v.max, (math.floor((mx - x - m.padding) / (m.width - 102) * (v.max - v.min) + v.min + 0.5))))
									surface.draw_filled_outlined_rect(
										x + m.padding + (199 - m.padding * 2) * v.s,
										y + 13 + m.padding * 2 + (200 - m.padding * 2) * clamp(1 - v.v, 0.001, 1),
										3, 3, 255, 255, 255, 255, 0, 0, 0, 255
									);
									surface.draw_outlined_rect(x + m.padding, y + 14 + m.padding * 2, 200 - m.padding * 2, 200 - m.padding * 2, 80, 80, 80, 255);

									for i = 1, 200 - m.padding * 2 do
										local r, g, b = hsvToRgb(1 - i / (200 - m.padding * 2), 1, 1, 255);
										surface.draw_outlined_rect(x + 200, y + 13 + m.padding * 2 + i, 15, 1, r, g, b, 255);
									end
									surface.draw_outlined_rect(x + 200, y + 14 + m.padding * 2, 15, 200 - m.padding * 2, 80, 80, 80, 255);

									if v.changeType == "vs" then
										v.v = 1.0001 - clamp((my - y - m.padding * 3) / (200 - m.padding * 2), 0, 1);
										v.s = clamp((mx - x - m.padding) / (200 - m.padding * 2), 0, 1);

										v.value = {hsvToRgb(v.h, v.s, v.v, v.value[4] / 255)};

										if not client.key_state(0x01) then
											v.changeType = nil;
										end
									end

									onIntersectPress(x + m.padding, y + 14 + m.padding * 2, 200 - m.padding * 2, 200 - m.padding * 2, function()
										if v.changeType == nil then
											v.changeType = "vs";
										end
									end)

									if v.changeType == "h" then
										v.h = 1.0001 - clamp((my - y - m.padding * 3) / (200 - m.padding * 2), 0, 1);

										v.value = {hsvToRgb(v.h, v.s, v.v, v.value[4] / 255)};

										if not client.key_state(0x01) then
											v.changeType = nil;
										end
									end

									onIntersectPress(x + 200, y + 13 + m.padding * 2, 15, 200 - m.padding * 2, function()
										if v.changeType == nil then
											v.changeType = "h";
										end
									end)

									if v.changeType == "a" then
										v.value[4] = clamp((my - y - m.padding * 3) / (200 - m.padding * 2), 0, 1) * 255;

										if not client.key_state(0x01) then
											v.changeType = nil;
										end
									end

									onIntersectPress(x + 230, y + 13 + m.padding * 2, 15, 200 - m.padding * 2, function()
										if v.changeType == nil then
											v.changeType = "a";
										end
									end)

									surface.draw_filled_outlined_rect(x + 199, y + 13 + m.padding * 2 + (200 - m.padding * 2) * clamp(1 - v.h, 0.001, 1), 17, 3, 255, 255, 255, 255, 0, 0, 0, 255);
									surface.draw_filled_outlined_rect(x + 229, y + 13 + m.padding * 2 + (200 - m.padding * 2) * clamp(v.value[4] / 255, 0, 1), 17, 3, 255, 255, 255, 255, 0, 0, 0, 255);
									surface.draw_outlined_rect(x + 230, y + 14 + m.padding * 2, 15, 200 - m.padding * 2, 80, 80, 80, 255);
								end
							end
						end
					end
				end
			end
		

			--[[if not client.key_state(0x01) and m.inSwitch ~= nil then
				m.inSwitch = nil;
			end]]

			scrollbarHeight = (m.height - 81) * clamp(visofst / ofst, 0, 1);

			surface.draw_filled_rect(m.x + m.width - 9, m.y + 51, 8, m.height - 77, 40, 40, 40, 255);
			surface.draw_filled_rect(m.x + m.width - 7, m.y + 53, 4, scrollbarHeight, 80, 80, 80, 255);
			-- endregion

			-- region menu stuff
			surface.draw_filled_rect(m.x + 1, m.y + 1, m.width - 2, 25, 22, 22, 22, 255); -- title bar
			surface.draw_text(m.x + 8, m.y + 6, 225, 225, 225, 255, m.font, m.title); -- title bar text
			surface.draw_filled_rect(m.x + 38, m.y + 26, m.width - 39, 25, 30, 30, 30, 255); -- subtab bar
			--surface.draw_filled_rect(m.x + 1, m.y + m.height - 26, m.width - 2, 25, 22, 22, 22, 255); -- bottom bar
			-- endregion

			-- region subtab menu
			for i = 1, #m.tabs do
				if m.tabs[i].name == m.currentTab then
					local ofst = 0;

					surface.draw_filled_rect(m.x + 3, m.y + 73 + ofst, 2, 29, m.accent[i], m.accent[2], m.accent[3], 255);
					

					for k = 1, #m.tabs[i].subtabs do
						local subtab = m.tabs[i].subtabs[k];
						local tw, th = surface.get_text_size(m.font, subtab);

						surface.draw_text(m.x + 38 + m.padding + ofst, m.y + 31, 225, 225, 225, 255, m.font, subtab);

						if not m.extendedTabs then
							onIntersectRelease(m.x + 38 + m.padding + ofst, m.y + 31, tw, th, function()
								m.currentSubtab = m.tabs[i].subtabs[k];
							end)
						end

						if m.currentSubtab == m.tabs[i].subtabs[k] then
							surface.draw_filled_rect(m.x + 38 + m.padding + ofst, m.y + 31 + th, tw, 1, m.accent[1], m.accent[2], m.accent[3], 255);
						elseif m.currentSubtab == nil then
							m.currentSubtab = m.tabs[i].subtabs[k]
						end

						ofst = ofst + tw + m.padding;
					end
				end
			end
			-- endregion

			-- region tab bar (draw extended tabs last because it overlaps menu elements)
			m.extendedTabsValue = m.extendedTabs and clamp(m.extendedTabsValue + globals.frametime() * 10, 0, 1) or clamp(m.extendedTabsValue - globals.frametime() * 10, 0, 1);

			surface.draw_filled_rect(m.x + 1, m.y + 26, clamp(200*m.extendedTabsValue, 37, 200), m.height - 27, 40, 40, 40, 255);
			surface.draw_filled_rect(m.x + 9, m.y + 37, 21, 1, 225, 225, 225, 255);
			surface.draw_filled_rect(m.x + 9, m.y + 44, 21, 1, 225, 225, 225, 255);
			surface.draw_filled_rect(m.x + 9, m.y + 51, 21, 1, 225, 225, 225, 255);

			for i = 1, #m.tabs do -- haha fuck optimization if it works its optimized :)
				local ofst = 35 * (i - 1);

				---------------- replace this with an image if u want icons ----------------
				renderer.texture(m.tabs[i].image,m.x + 9, m.y + 77 + ofst, 21, 21, 255, 255, 255, 255,"f");
				----------------------------------------------------------------------------

				if m.extendedTabsValue > 0.75 then
					surface.draw_text(m.x + 30 + m.padding, m.y + 80 + ofst, 255, 255, 255, 255, m.font, m.tabs[i].name);
				end

				if intersects(m.x + 1, m.y + 72 + ofst, m.extendedTabs and 200 or 37, 31) and m.currentTab ~= m.tabs[i].name then
					surface.draw_filled_rect(m.x + 1, m.y + 72 + ofst, clamp(200*m.extendedTabsValue, 37, 200), 31, 200, 200, 200, 50);
		
					if unClick(0x01) then
						m.currentTab = m.tabs[i].name;
						m.currentSubtab = m.tabs[i].subtabs[1] or nil;
						m.extendedTabs = false;
					end
				end

				if m.currentTab == m.tabs[i].name then
					surface.draw_filled_rect(m.x + 3, m.y + 73 + ofst, 2, 29, m.accent[i], m.accent[2], m.accent[3], 255);
				elseif m.currentTab == nil then
					m.currentTab = m.tabs[i].name;
					m.currentSubtab = m.tabs[i].subtabs[1] or nil;
				end
			end

			-- tabs seperator
			surface.draw_filled_rect(m.x + 11, m.y + 65, clamp(180*m.extendedTabsValue, 17, 180), 1, 60, 60, 60, 255);

			if intersects(m.x + 1, m.y + 29, m.extendedTabs and 200 or 37, 31) then
				surface.draw_filled_rect(m.x + 1, m.y + 29, clamp(200*m.extendedTabsValue, 37, 200), 31, 200, 200, 200, 50);

				if unClick(0x01) then
					m.extendedTabs = not m.extendedTabs;
				end
			end

			if not intersects(m.x + 1, m.y + 29, 200, m.height - 27) and m.extendedTabs and unClick(0x01) then
				m.extendedTabs = false;
			end
			-- endregion
		else
			m.extendedTabs = false;
			m.extendedTabsValue = 0;
			for k, v in pairs(m.elements) do
				if v.type == "hotkey" then
					if v.state == "always on" then
						v.value = true;
					elseif v.state == "holding" then
						v.value = client.key_state(v.key);
					elseif v.state == "off hotkey" then
						v.value = not client.key_state(v.key);
					elseif v.state == "toggle" then
						if v.canSwitch then
							v.value = not v.value;
							v.canSwitch = false;
						end
					end
				end
			end
		end
	end

	return self;
end

--#region Menu Improvements
client.set_event_callback("setup_command", function(e)
	if ui.is_menu_open() then
		e.in_attack = 0
	end
	end)
--#endregion

-- endregion

local menu = Framework.new("basedSecurity MasterLoader");

local menuElements 

local function constructLuaTab(menu,location,lua)
	menu.newTab(location, rage_svg)
	for k,v in ipairs(lua) do
		menu.newSubtab(location,v)
		table.insert(menuElements.multiSelect, menu.newCombobox(location,v,"Select version",{"Live","Beta","Alpha"}))
		table.insert(menuElements.buttons, menu.newCheckbox(location,v,"Load lua"))
	end
end


local function menu(menu)

	menuElements = {
		multiSelect = {

		},

		buttons = {

		},

		settings = {

		}
	}
	constructLuaTab(menu,"Luas A",{"AURA","GLORIOUS","MANGO","MATRIX","MORPHEUS"})

	constructLuaTab(menu,"Luas B",{"PREDICTION","OXYGEN","REVISON","TOUCAN","WHITEOUT"})

	menu.newTab("MISC", misc_svg);
	menu.newSubtab("MISC", "Settings")
	menu.newSubtab("MISC", "Info")


	client.set_event_callback("paint_ui",function()
		menu.draw()
	end)
end

local function observeForLoad(menu, location)
    for i, v in ipairs(location) do
        print("test")
        if menu.get(v) then
            print("Detected true value")
        end
    end
end

menu(menu)

client.set_event_callback("paint_ui",observeForLoad(menu,menuElements.buttons))

