#include "mruby.h"
#include "mruby/irep.h"

static mrb_value this_is_c(mrb_state* mrb, mrb_value self) {
    printf("hello from C\n");
    return mrb_true_value();
}

int main(int argc, char *argv[]) {
    mrb_state *mrb = mrb_open();

    struct RClass *ruby2d_module = mrb_define_module(mrb, "Avian");
    struct RClass *ruby2d_triangle_class = mrb_define_class_under(mrb, ruby2d_module, "CBridge", mrb->object_class);
    mrb_define_method(mrb, ruby2d_triangle_class, "this_is_c", this_is_c, MRB_ARGS_NONE());

    mrb_load_irep(mrb, app);

    mrb_close(mrb);
}
