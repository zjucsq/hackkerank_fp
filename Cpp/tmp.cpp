#include <bits/stdc++.h>
using namespace std;

inline int convert(int x, int y, int m) { return x * m + y; }

struct dis {
  int d_ = 9999999;
  bool unique = true;
};

struct node {
  int x = 0;
  int y = 0;
  int d_ = 0;
};

int main() {
  int n, m;
  cin >> n >> m;
  // 0:empty
  vector<vector<int>> g(n, vector<int>(m, 0));

  int init_x, init_y;
  for (int i = 0; i < n; ++i) {
    string s;
    cin >> s;
    for (int j = 0; j < m; ++j) {
      if (s[j] == '*') {
        g[i][j] = 1;
      }
      if (s[j] == 'R') {
        init_x = i;
        init_y = j;
      }
    }
  }

  vector<vector<dis>> d(m * n, vector<dis>(n * m));
  for (int i = 0; i < m * n; ++i) {
    d[i][i].d_ = 0;
  }

  int start_x = 0;
  int start_y = 0;

  function<void(int, int)> bfs = [&](int x, int y) {
    queue<node> q;
    q.push(node{x, y, 0});
    vector<vector<int>> vis(n, vector<int>(m, 0));
    vis[x][y] = 1;
    while (!q.empty()) {
      auto t = q.front();
      int cx = t.x;
      int cy = t.y;
      int d_ = t.d_;
      // cout << q.size() << ' ' << cx << ' ' << cy << ' ' << d_ << endl;
      q.pop();
      // if (vis[cx][cy])
      //     continue;

      // if (d_ < d[convert(x, y, m)][convert(cx, cy, m)].d_) {
      //   d[convert(x, y, m)][convert(cx, cy, m)].d_ = d_;
      //   d[convert(x, y, m)][convert(cx, cy, m)].unique = true;
      // } else if (d_ == d[convert(x, y, m)][convert(cx, cy, m)].d_) {
      //   d[convert(x, y, m)][convert(cx, cy, m)].unique = false;
      // }

      if (cx + 1 < n && g[cx + 1][cy] == 0) {
        if (d_ + 1 < d[convert(x, y, m)][convert(cx + 1, cy, m)].d_) {
          d[convert(x, y, m)][convert(cx + 1, cy, m)].d_ = d_ + 1;
          d[convert(x, y, m)][convert(cx + 1, cy, m)].unique = true;
        } else if (d_ + 1 == d[convert(x, y, m)][convert(cx + 1, cy, m)].d_) {
          d[convert(x, y, m)][convert(cx + 1, cy, m)].unique = false;
        }
        if (!vis[cx + 1][cy]) {
          q.push(node{cx + 1, cy, d_ + 1});
          vis[cx + 1][cy] = 1;
        }
      }
      if (cx - 1 >= 0 && g[cx - 1][cy] == 0) {
        if (d_ + 1 < d[convert(x, y, m)][convert(cx - 1, cy, m)].d_) {
          d[convert(x, y, m)][convert(cx - 1, cy, m)].d_ = d_ + 1;
          d[convert(x, y, m)][convert(cx - 1, cy, m)].unique = true;
        } else if (d_ + 1 == d[convert(x, y, m)][convert(cx - 1, cy, m)].d_) {
          d[convert(x, y, m)][convert(cx - 1, cy, m)].unique = false;
        }
        if (!vis[cx - 1][cy]) {
          q.push(node{cx - 1, cy, d_ + 1});
          vis[cx - 1][cy] = 1;
        }
      }
      if (cy + 1 < m && g[cx][cy + 1] == 0) {
        if (d_ + 1 < d[convert(x, y, m)][convert(cx, cy + 1, m)].d_) {
          d[convert(x, y, m)][convert(cx, cy + 1, m)].d_ = d_ + 1;
          d[convert(x, y, m)][convert(cx, cy + 1, m)].unique = true;
        } else if (d_ + 1 == d[convert(x, y, m)][convert(cx, cy + 1, m)].d_) {
          d[convert(x, y, m)][convert(cx, cy + 1, m)].unique = false;
        }
        if (!vis[cx][cy + 1]) {
          q.push(node{cx, cy + 1, d_ + 1});
          vis[cx][cy + 1] = 1;
        }
      }
      if (cy - 1 >= 0 && g[cx][cy - 1] == 0) {
        if (d_ + 1 < d[convert(x, y, m)][convert(cx, cy - 1, m)].d_) {
          d[convert(x, y, m)][convert(cx, cy - 1, m)].d_ = d_ + 1;
          d[convert(x, y, m)][convert(cx, cy - 1, m)].unique = true;
        } else if (d_ + 1 == d[convert(x, y, m)][convert(cx, cy - 1, m)].d_) {
          d[convert(x, y, m)][convert(cx, cy - 1, m)].unique = false;
        }
        if (!vis[cx][cy - 1]) {
          q.push(node{cx, cy - 1, d_ + 1});
          vis[cx][cy - 1] = 1;
        }
      }
    }
  };

  for (start_x = 0; start_x < n; ++start_x) {
    for (start_y = 0; start_y < m; ++start_y) {
      if (g[start_x][start_y] == 0) {
        bfs(start_x, start_y);
      }
    }
  }

  //   for (int i = 0; i < n*m; ++i) {
  //       for (int j = 0; j < n * m; ++j) {
  //           auto t = d[i][j];
  //           cout << i << " "<< j << ' ' << t.d_ << ' ' << t.unique << endl;
  //       }
  //   }

  string s;
  cin >> s;
  // cout << "ok " << endl;
  int prev_click = -1;
  int px = init_x;
  int py = init_y;
  int cx_1 = init_x;
  int cy_1 = init_y;
  int cx = init_x;
  int cy = init_y;
  int res = 1;
  // cout << init_x << init_y << endl;
  for (int i = 0; i < s.size(); ++i) {
    cy_1 = cy;
    cx_1 = cx;
    if (s[i] == 'A') {
      cy--;
    } else if (s[i] == 'W') {
      cx--;
    } else if (s[i] == 'S') {
      cx++;
    } else if (s[i] == 'D') {
      cy++;
    }
    // cout << cx << cy << endl;
    if (d[convert(px, py, m)][convert(cx, cy, m)].d_ != i - prev_click ||
        !d[convert(px, py, m)][convert(cx, cy, m)].unique) {
      prev_click = i - 1;
      // cout << cx << cy << prev_click << endl;
      ++res;
      px = cx_1;
      py = cy_1;
    }
  }

  cout << res << endl;
}
// 64 位输出请用 printf("%lld")