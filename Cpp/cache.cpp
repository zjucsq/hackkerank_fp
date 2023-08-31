// https://zhuanlan.zhihu.com/p/414652868 C++函数装饰器

#include <functional>
#include <iostream>
#include <map>
#include <tuple>
#include <unordered_map>

// 为某个类型提供hash的四种方法
// https://blog.csdn.net/qq_45311905/article/details/121488048
// 怎么给tuple自定义hash
// https://codereview.stackexchange.com/questions/136770/hashing-a-tuple-in-c17
// template <typename Tuple, std::size_t... ids>
// std::size_t tupleHash(Tuple const &tuple, std::index_sequence<ids...> const
// &) {
//   std::size_t result = 0;
//   for (auto const &hash :
//        {std::hash<std::decay_t<decltype(std::get<ids>(tuple))>>()(
//            std::get<ids>(tuple))...}) {
//     result ^= hash + 0x9e3779b9 + (result << 6) + (result >> 2);
//   }
//   return result;
// };
// template <typename... Ts> class std::hash<std::tuple<Ts...>> {
// public:
//   size_t operator()(const std::tuple<Ts...> &t) const {
//     return tupleHash(t, std::make_index_sequence<sizeof...(Ts)>());
//   }
// };
// A simpler version
template <typename... Ts> class std::hash<std::tuple<Ts...>> {
public:
  size_t operator()(const std::tuple<Ts...> &key) const {
    return std::apply(
        [](const auto &...args) {
          std::size_t seed = 0;
          ((seed ^= std::hash<std::decay_t<decltype(args)>>{}(args) +
                    0x9e3779b9 + (seed << 6) + (seed >> 2)),
           ...);
          return seed;
        },
        key);
  }
};

// https://zhuanlan.zhihu.com/p/102240099
namespace detail {

template <typename R, typename... As> struct __function_traits_base {
  using function_type = std::function<R(As...)>;

  using result_type = R;

  using argument_types = std::tuple<As...>;
};

template <typename F> struct __function_traits;
template <typename F>
struct __function_traits<std::reference_wrapper<F>>
    : public __function_traits<F> {};
template <typename R, typename... As>
struct __function_traits<R (*)(As...)>
    : public __function_traits_base<R, As...> {};
template <typename R, typename C, typename... As>
struct __function_traits<R (C::*)(As...)>
    : public __function_traits_base<R, As...> {};
template <typename R, typename C, typename... As>
struct __function_traits<R (C::*)(As...) const>
    : public __function_traits_base<R, As...> {};
template <typename F>
struct __function_traits : public __function_traits<decltype(&F::operator())> {
};

} // namespace detail

// Only work for non-recursive functions.
template <typename F> class Memorize;
template <typename Ret, typename... Args>
class Memorize<std::function<Ret(Args...)>> {
  using func_type = std::function<Ret(Args...)>;

public:
  Memorize(func_type func) : func(func) {}

  Ret operator()(Args... args) {
    const auto args_tuple = std::make_tuple(args...);
    const auto it = cache.find(args_tuple);

    if (it == cache.end()) {
      const auto res = func(args...);
      cache[args_tuple] = res;
      return res;
    } else {
      return it->second;
    }
  }

  void set_func(func_type new_func) { func = new_func; }

private:
  func_type func;
  std::unordered_map<std::tuple<Args...>, Ret> cache;
};

int fib(int n) { return n <= 1 ? n : fib(n - 1) + fib(n - 2); }

template <typename Ret, typename... Args>
auto make_norec(Ret (*func)(Args...)) {
  return func;
}

int fib_norec(std::function<int(int)> f, int n) {
  return n <= 1 ? n : f(n - 1) + f(n - 2);
}

template <typename F, typename F_rec> class Memorize_rec;
template <typename Ret, typename... Args, typename Arg_fun>
class Memorize_rec<std::function<Ret(Arg_fun, Args...)>,
                   std::function<Ret(Args...)>> {
  using func_norec_type = std::function<Ret(Arg_fun, Args...)>;
  using func_rec_type = std::function<Ret(Args...)>;

public:
  Memorize_rec(func_norec_type func_norec, func_rec_type func_rec)
      : func_norec(func_norec), func_rec(func_rec),
        memo(static_cast<func_rec_type>([this](Args... args) {
          return this->func_norec(
              std::bind(&Memorize_rec::operator(), this, std::placeholders::_1),
              args...);
        })) {}

  Ret operator()(Args... args) { return memo(args...); }

private:
  func_norec_type func_norec;
  func_rec_type func_rec;
  Memorize<func_rec_type> memo;
};

int main() {
  // Memorize_rec<decltype(fib_norec)> m{fib_norec};
  std::function<int(int)> f(fib);
  Memorize<decltype(f)> m{f};

  std::cout << "Result 1: " << m(40) << std::endl;
  std::cout << "Result 2: " << m(40) << std::endl;

  std::function<int(std::function<int(int)>, int)> f_norec(fib_norec);
  Memorize_rec<decltype(f_norec), decltype(f)> m_rec{f_norec, f};

  std::cout << "Result 1: " << m_rec(45) << std::endl;
  std::cout << "Result 2: " << m_rec(45) << std::endl;

  return 0;
}
