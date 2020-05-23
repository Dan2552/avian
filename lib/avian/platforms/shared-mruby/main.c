#include "options.h"
#include "app.h"
#include "mruby.h"
#include "mruby/irep.h"
#include "mruby/string.h"
#include "SDL.h"
#include "SDL_image.h"
#include <stdio.h>
#include <stdlib.h>

SDL_Window *window;
SDL_Renderer *renderer;
SDL_Event event;

SDL_Texture *textures[100];
int textures_count = 0;

int screen_width;
int screen_height;

static mrb_value provision_sdl(mrb_state* mrb, mrb_value self) {
    printf("provision_sdl\n");

#if MOBILE
    window = SDL_CreateWindow(NULL, 0, 0, NULL, NULL, SDL_WINDOW_OPENGL|SDL_WINDOW_FULLSCREEN);
#else
    window = SDL_CreateWindow(NULL, 0, 0, 1125 / 3, 2436 / 3, SDL_WINDOW_OPENGL);
#endif
    renderer = SDL_CreateRenderer(window, -1, 0);

    SDL_DisplayMode display_mode;
    SDL_GetCurrentDisplayMode(0, &display_mode);
    screen_width = display_mode.w;
    screen_height = display_mode.h;

    return mrb_nil_value();
}

static mrb_value update_inputs(mrb_state* mrb, mrb_value self) {
    printf("update_inputs\n");
    while (SDL_PollEvent(&event)) {
        if (event.type == SDL_QUIT) {
            printf("SDL_QUIT");
            // let's hope we don't need this
        }
    }

    return mrb_nil_value();
}

static mrb_value clear_screen(mrb_state* mrb, mrb_value self) {
    printf("clear_screen\n");
    SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
    SDL_RenderClear(renderer);

    return mrb_nil_value();
}

static mrb_value draw_test_rect(mrb_state* mrb, mrb_value self) {
    printf("draw_test_rect\n");
    SDL_Rect rect;

    /*  Come up with a random rectangle */
    rect.w = 128;
    rect.h = 128;
    rect.x = 0;
    rect.y = 0;

    SDL_SetRenderDrawColor(renderer, 255, 0, 0, 255);

    /*  Fill the rectangle in the color */
    SDL_RenderFillRect(renderer, &rect);

    /* update screen */
    SDL_RenderPresent(renderer);

    return mrb_nil_value();
}

static mrb_value create_texture(mrb_state* mrb, mrb_value self) {
    const char *texture_name;
    mrb_get_args(mrb, "z", &texture_name);

    SDL_Texture *new_texture;
    SDL_Surface *loaded_surface = IMG_Load(texture_name);

    if (loaded_surface == NULL) {
        printf("Unable to load image %s! SDL_image Error: %s\n", texture_name, IMG_GetError());
    } else {
        //Create texture from surface pixels
        new_texture = SDL_CreateTextureFromSurface(renderer, loaded_surface);
        if (new_texture == NULL) {
            printf("Unable to create texture from %s! SDL Error: %s\n", texture_name, SDL_GetError());
        }

        textures[textures_count] = new_texture;
        textures_count++;

        //Get rid of old loaded surface
        SDL_FreeSurface(loaded_surface);
    }

    return mrb_fixnum_value(textures_count - 1);
}

static mrb_value draw_image(mrb_state* mrb, mrb_value self) {
    int texture_index;
    int x;
    int y;
//    int z;
//    double angle;
//    int center_x;
//    int center_y;

    mrb_get_args(mrb, "iii", &texture_index, &x, &y);

    SDL_Texture *texture = textures[texture_index];

    int width = 100;
    int height = 100;

    x = x + screen_width / 2;
    y = y + screen_height / 2;

    x = x - width / 2;
    y = y - height / 2;

    SDL_Rect destination = { .x = x, .y = y, .w = width, .h = height };

    SDL_RenderCopy(renderer, texture, NULL, &destination);
    SDL_RenderPresent(renderer);
//    mrb_get_args(mrb,
//                 "iiifii",
//                &x,
//                 &y,
//                 &z,
//                 &angle,
//                 &center_x,
//                 &center_y);

    return mrb_nil_value();
}

int main(int argc, char *argv[]) {
    printf("started\n");

    mrb_state *mrb = mrb_open();
    struct RClass *ruby_module_avian = mrb_define_module(mrb, "Avian");
    struct RClass *ruby_class_c_bridge = mrb_define_class_under(mrb, ruby_module_avian, "CBridge", mrb->object_class);

    // C functions for Ruby to call defined here
    mrb_define_method(mrb, ruby_class_c_bridge, "provision_sdl", provision_sdl, MRB_ARGS_NONE());
    mrb_define_method(mrb, ruby_class_c_bridge, "update_inputs", update_inputs, MRB_ARGS_NONE());
    mrb_define_method(mrb, ruby_class_c_bridge, "clear_screen", clear_screen, MRB_ARGS_NONE());
    mrb_define_method(mrb, ruby_class_c_bridge, "draw_test_rect", draw_test_rect, MRB_ARGS_NONE());
    mrb_define_method(mrb, ruby_class_c_bridge, "create_texture", create_texture, MRB_ARGS_ANY());
    mrb_define_method(mrb, ruby_class_c_bridge, "draw_image", draw_image, MRB_ARGS_ANY());

    mrb_load_irep(mrb, app);
    mrb_close(mrb);
    SDL_Quit();

    return 0;
}
