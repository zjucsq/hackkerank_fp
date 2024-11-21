#include <string>
#include <cctype>
#include <utility>
#include <vector>
#include <functional>
#include <optional>
#include <cmath>

class Input_t {
public:
    std::string str;
    size_t idx;

    Input_t(std::string s, size_t index = 0) : str(std::move(s)), idx(index) {}

    char get_char() {
        if (idx == str.length()) {
            return '\0'; // Using '\0' to represent the end of the string
        }
        return str[idx];
    }

    Input_t next() {
        return Input_t(str, idx + 1);
    }
};

template <typename T>
using ParserResult = std::pair<std::optional<T>, Input_t>;
using ParserFunction = std::function<ParserResult(Input_t)>;

ParserResult char_parser(Input_t input, char c) {
    if (input.get_char() == c) {
        return {c, input.next()};
    }
    return {0, input}; // Using 0 to represent None
}

ParserFunction p_and(const ParserFunction& parser1, const ParserFunction& parser2) {
    return [parser1, parser2](Input_t input) -> ParserResult {
        auto [r1, i1] = parser1(input);
        if (r1 == 0) {
            return {0, input};
        }
        auto [r2, i2] = parser2(i1);
        if (r2 == 0) {
            return {0, input};
        }
        return {{r1, r2}, i2}; // Using std::pair to represent the tuple
    };
}

ParserFunction p_or(const ParserFunction& parser1, const ParserFunction& parser2) {
    return [parser1, parser2](Input_t input) -> ParserResult {
        auto [r1, i1] = parser1(input);
        if (r1 != 0) {
            return {r1, i1};
        }
        auto [r2, i2] = parser2(input);
        if (r2 != 0) {
            return {r2, i2};
        }
        return {0, input};
    };
}

ParserFunction p_many(const ParserFunction& parser) {
    return [parser](Input_t input) -> ParserResult {
        std::vector<int> res;
        while (true) {
            auto [r, i] = parser(input);
            if (r == 0) {
                return {res, i}; // Using std::vector to represent the list
            }
            res.push_back(r);
            input = i;
        }
    };
}

ParserFunction p_many1(const ParserFunction& parser) {
    return p_and(parser, p_many(parser));
}

ParserFunction add_parser = [](Input_t input) { return char_parser(input, '+'); };
ParserFunction sub_parser = [](Input_t input) { return char_parser(input, '-'); };
ParserFunction mul_parser = [](Input_t input) { return char_parser(input, '*'); };
ParserFunction div_parser = [](Input_t input) { return char_parser(input, '/'); };
ParserFunction lbr_parser = [](Input_t input) { return char_parser(input, '('); };
ParserFunction rbr_parser = [](Input_t input) { return char_parser(input, ')'); };

ParserFunction addsub_parser = p_or(add_parser, sub_parser);
ParserFunction muldiv_parser = p_or(mul_parser, div_parser);

ParserFunction int_parser = [](Input_t input) -> ParserResult {
    if (std::isdigit(input.get_char())) {
        int res = 0;
        while (std::isdigit(input.get_char())) {
            res = res * 10 + input.get_char() - '0';
            input = input.next();
        }
        return {res, input};
    }
    return {0, input};
};

ParserFunction expr_parser, term_parser, factor_parser;

int calculate(std::string s) {
    s.erase(std::remove(s.begin(), s.end(), ' '), s.end());
    Input_t input(s);
    auto [r, i] = expr_parser(input);
    return r;
}

int main() {
    // Define expr_parser, term_parser, factor_parser here to avoid circular dependency
    expr_parser = [](Input_t input) -> ParserResult {
        auto [r, input_1] = p_and(term_parser, p_many(
            p_and(addsub_parser, term_parser)))(input);
        int res = r;
        auto lst = input_1;
        // Process list to calculate expression result
        // ...
        return {res, input_1};
    };

    term_parser = [](Input_t input) -> ParserResult {
        auto [r, input_1] = p_and(factor_parser, p_many(
            p_and(muldiv_parser, factor_parser)))(input);
        int res = r;
        auto lst = input_1;
        // Process list to calculate term result
        // ...
        return {res, input_1};
    };

    factor_parser = [](Input_t input) -> ParserResult {
        auto [r, i] = int_parser(input);
        if (r != 0) {
            return {r, i};
        }
        // Process for addsub_parser, lbr_parser, and rbr_parser
        // ...
        return {0, input};
    };

    // Use the calculate function to get the result of an arithmetic expression
    std::string expression = "3 + 5 * (10 - 2)";
    int result = calculate(expression);
    std::cout << "Result: " << result << std::endl;

    return 0;
}
