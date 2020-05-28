#include "options.h"
#include "app.h"
#include "mruby.h"
#include "mruby/irep.h"
#include "mruby/string.h"
#include "mruby/array.h"
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
double device_scale;
int mouse_down = 0;

// E.g. if device_scale is 2, this should be double screen_width
int render_screen_width;
int render_screen_height;

static mrb_value provision_sdl(mrb_state *mrb, mrb_value self) {
    printf("provision_sdl\n");

#if MOBILE
    window = SDL_CreateWindow(NULL, 0, 0, NULL, NULL, SDL_WINDOW_OPENGL|SDL_WINDOW_FULLSCREEN|SDL_WINDOW_ALLOW_HIGHDPI);
    SDL_DisplayMode display_mode;
    SDL_GetCurrentDisplayMode(0, &display_mode);
    renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_PRESENTVSYNC);
    SDL_GetRendererOutputSize(renderer, &render_screen_width, &render_screen_height);
    device_scale = 3;
    screen_width = render_screen_width / device_scale;
    screen_height = render_screen_height / device_scale;
#else
    // (1 - 1/3)
    // device_scale = 0.6666666;
    device_scale = 2;
    screen_width = 1125 / 3;
    screen_height = 2436 / 3;

    // printf("SCREEN %i %i\n", screen_width, screen_height);

    window = SDL_CreateWindow(NULL, 0, 0, screen_width, screen_height, SDL_WINDOW_OPENGL|SDL_WINDOW_ALLOW_HIGHDPI);
    renderer = SDL_CreateRenderer(window, -1, 0);
    // SDL_RenderSetScale(renderer, 0.6666666, 0.6666666);
    SDL_GetRendererOutputSize(renderer, &render_screen_width, &render_screen_height);
    // printf("SCREEN %i %i\n", screen_width, screen_height);
#endif

    printf("screen size: %i, %i\n", screen_width, screen_height);
    return mrb_nil_value();
}

static mrb_value get_screen_width(mrb_state *mrb, mrb_value self) {
    return mrb_fixnum_value(screen_width);
}

static mrb_value get_screen_height(mrb_state *mrb, mrb_value self) {
    return mrb_fixnum_value(screen_height);
}

static mrb_value update_inputs(mrb_state *mrb, mrb_value self) {
    int x = 0;
    int y = 0;
    long id = 0;
    char *state = "empty";

#if MOBILE
    if (SDL_PollEvent(&event)) {
        switch(event.type){
            case SDL_QUIT:
                state = "quit";
                break;
            case SDL_FINGERDOWN:
                if (mouse_down == 0) {
                    mouse_down = 1;
                    state = "touch_down";
                    id = event.tfinger.fingerId;
                    x = event.tfinger.x * screen_width;
                    y = event.tfinger.y * screen_height;
                }
                break;
            case SDL_FINGERMOTION:
                if (mouse_down == 1) {
                  state = "touch_move";
                  id = event.tfinger.fingerId;
                  x = event.tfinger.x * screen_width;
                  y = event.tfinger.y * screen_height;
                    printf("(C) %i %i\n", x, y);
                }
                break;
            case SDL_FINGERUP:
                if (mouse_down == 1) {
                  mouse_down = 0;
                  state = "touch_up";
                  id = event.tfinger.fingerId;
                  x = event.tfinger.x * screen_width;
                  y = event.tfinger.y * screen_height;
                }
                break;
        }
    }
#else
    if (SDL_PollEvent(&event)) {
        switch(event.type){
            case SDL_QUIT:
                state = "quit";
                break;
            case SDL_MOUSEBUTTONDOWN:
                if (mouse_down == 0) {
                  mouse_down = 1;
                  state = "touch_down";
                  id = 1;
                  x = event.motion.x;
                  y = event.motion.y;
                }
                break;
            case SDL_MOUSEMOTION:
                if (mouse_down == 1) {
                  state = "touch_move";
                  id = 1;
                  x = event.motion.x;
                  y = event.motion.y;
                }
                break;
            case SDL_MOUSEBUTTONUP:
                if (mouse_down == 1) {
                  mouse_down = 0;
                  state = "touch_up";
                  id = 1;
                  x = event.motion.x;
                  y = event.motion.y;
                }
                break;
        }
    }

    // x = x * device_scale;
    // y = y * device_scale;
#endif

    int more = SDL_PollEvent(NULL);
    mrb_value values[5];
    values[0] = mrb_fixnum_value(more);
    values[1] = mrb_symbol_value(mrb_intern_cstr(mrb, state));
    values[2] = mrb_fixnum_value(id);
    values[3] = mrb_fixnum_value(x);
    values[4] = mrb_fixnum_value(y);
    return mrb_ary_new_from_values(mrb, 5, values);
}

static mrb_value clear_screen(mrb_state *mrb, mrb_value self) {
    SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
    SDL_RenderClear(renderer);

    return mrb_nil_value();
}

static mrb_value create_texture(mrb_state *mrb, mrb_value self) {
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

    printf("texture created: %i\n", textures_count - 1);
    return mrb_fixnum_value(textures_count - 1);
}

static mrb_value draw_image(mrb_state *mrb, mrb_value self) {
    mrb_int texture_index;
    mrb_int x;
    mrb_int y;
    mrb_int z;
    mrb_float angle;
    mrb_int center_x;
    mrb_int center_y;
    mrb_float x_scale;
    mrb_float y_scale;
    mrb_int camera_x;
    mrb_int camera_y;
    mrb_float camera_x_scale;
    mrb_float camera_y_scale;

    mrb_get_args(
      mrb,
      "iiiifiiffiiff",
      &texture_index,
      &x,
      &y,
      &z,
      &angle,
      &center_x,
      &center_y,
      &x_scale,
      &y_scale,
      &camera_x,
      &camera_y,
      &camera_x_scale,
      &camera_y_scale
    );

    // printf("(c---) texture_index: %lld, x: %lld, y: %lld, z: %lld, angle: %f, center_x: %lld, center_y: %lld, x_scale: %f, y_scale: %f, camera_x: %lld, camera_y: %lld, camera_x_scale: %f, camera_y_scale: %f\n", texture_index, x, y, z, angle, center_x, center_y, x_scale, y_scale, camera_x, camera_y, camera_x_scale, camera_y_scale);

    SDL_Texture *texture = textures[texture_index];

    int width;
    int height;
    SDL_QueryTexture(texture, NULL, NULL, &width, &height);

    // images are at 2x the size, so normalize back to 1x scale
    width = width * 0.5;
    height = height * 0.5;

    camera_x_scale = camera_x_scale * device_scale;
    camera_y_scale = camera_y_scale * device_scale;

    x_scale = x_scale * camera_x_scale;
    y_scale = y_scale * camera_y_scale;

    width = width * x_scale;
    height = height * y_scale;

    // Scale position in general by camera scale
    x = x * camera_x_scale;
    y = y * camera_y_scale;

    // Normalize 0,0 to center of screen and center of sprite
    x = x + render_screen_width * 0.5;
    y = y + render_screen_height * 0.5;
    x = x - width * 0.5;
    y = y - height * 0.5;

    // Adjust for camera position
    // x = x - camera_x * camera_x_scale;
    // y = y - camera_y * camera_y_scale;

    SDL_Rect destination = {
      .x = x,
      .y = y,
      .w = (width) + 1, // TODO: instead of +1 try rounding
      .h = (height) + 1
    };

    SDL_RenderCopy(renderer, texture, NULL, &destination);

    return mrb_nil_value();
}

static mrb_value render(mrb_state *mrb, mrb_value self) {
  SDL_RenderPresent(renderer);
  return mrb_nil_value();
}

static mrb_value sleep(mrb_state *mrb, mrb_value self) {
  mrb_float seconds;
  mrb_get_args(mrb, "f", &seconds);
  SDL_Delay(seconds * 1000);

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
    mrb_define_method(mrb, ruby_class_c_bridge, "create_texture", create_texture, MRB_ARGS_ANY());
    mrb_define_method(mrb, ruby_class_c_bridge, "draw_image", draw_image, MRB_ARGS_ANY());
    mrb_define_method(mrb, ruby_class_c_bridge, "get_screen_width", get_screen_width, MRB_ARGS_NONE());
    mrb_define_method(mrb, ruby_class_c_bridge, "get_screen_height", get_screen_height, MRB_ARGS_NONE());
    mrb_define_method(mrb, ruby_class_c_bridge, "render", render, MRB_ARGS_NONE());
    mrb_define_method(mrb, ruby_class_c_bridge, "sleep", sleep, MRB_ARGS_ANY());

    mrb_load_irep(mrb, app);
    if (mrb->exc) mrb_print_error(mrb);
    mrb_close(mrb);
    SDL_Quit();

    return 0;
}
