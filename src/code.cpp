#include <cpp11.hpp>
using namespace cpp11;

[[cpp11::register]]
int add(double a, double b) {
  return a + b;
}

[[cpp11::register]]
int times(double a, double b) {
  return a * b;
}
