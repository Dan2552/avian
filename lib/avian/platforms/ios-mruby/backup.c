#include "ruby_app.h"
#include "mruby.h"
#include "mruby/irep.h"
#include "mruby/string.h"
#include "SDL.h"
#include <stdio.h>
#include <stdlib.h>
#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 480




SDL_Window *window;
SDL_Renderer *renderer;
SDL_Event event;

static mrb_value provision_sdl(mrb_state* mrb, mrb_value self) {
    printf("provision_sdl\n");

    window = SDL_CreateWindow(NULL, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, SDL_WINDOW_OPENGL);
    renderer = SDL_CreateRenderer(window, -1, 0);

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

    printf(texture_name);

//    SDL_Texture *new_texture;

//    SDL_Surface *loaded_surface = IMG_LOAD(texture_name);


    return mrb_nil_value();
}

//SDL_Texture* loadTexture(  path )
//{
//    //The final texture
//    SDL_Texture* newTexture = NULL;
//
//    //Load image at specified path
//    SDL_Surface* loadedSurface = IMG_Load( path.c_str() );
//    if( loadedSurface == NULL )
//    {
//        printf( "Unable to load image %s! SDL_image Error: %s\n", path.c_str(), IMG_GetError() );
//    }
//    else
//    {
//        //Create texture from surface pixels
//        newTexture = SDL_CreateTextureFromSurface( gRenderer, loadedSurface );
//        if( newTexture == NULL )
//        {
//            printf( "Unable to create texture from %s! SDL Error: %s\n", path.c_str(), SDL_GetError() );
//        }
//
//        //Get rid of old loaded surface
//        SDL_FreeSurface( loadedSurface );
//    }
//
//    return newTexture;
//}


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

    mrb_load_irep(mrb, app);
    mrb_close(mrb);
    SDL_Quit();

    return 0;
}
