#include <bits/stdc++.h>

using namespace std;

template <typename A, typename B>
string to_string(pair<A, B> p);

template <typename A, typename B, typename C>
string to_string(tuple<A, B, C> p);

template <typename A, typename B, typename C, typename D>
string to_string(tuple<A, B, C, D> p);

string to_string(const string& s) {
  return '"' + s + '"';
}

string to_string(const char* s) {
  return to_string((string) s);
}

string to_string(bool b) {
  return (b ? "true" : "false");
}

string to_string(vector<bool> v) {
  bool first = true;
  string res = "{";
  for (int i = 0; i < static_cast<int>(v.size()); i++) {
    if (!first) {
      res += ", ";
    }
    first = false;
    res += to_string(v[i]);
  }
  res += "}";
  return res;
}

template <size_t N>
string to_string(bitset<N> v) {
  string res = "";
  for (size_t i = 0; i < N; i++) {
    res += static_cast<char>('0' + v[i]);
  }
  return res;
}

template <typename A>
string to_string(A v) {
  bool first = true;
  string res = "{";
  for (const auto &x : v) {
    if (!first) {
      res += ", ";
    }
    first = false;
    res += to_string(x);
  }
  res += "}";
  return res;
}

template <typename A, typename B>
string to_string(pair<A, B> p) {
  return "(" + to_string(p.first) + ", " + to_string(p.second) + ")";
}

template <typename A, typename B, typename C>
string to_string(tuple<A, B, C> p) {
  return "(" + to_string(get<0>(p)) + ", " + to_string(get<1>(p)) + ", " + to_string(get<2>(p)) + ")";
}

template <typename A, typename B, typename C, typename D>
string to_string(tuple<A, B, C, D> p) {
  return "(" + to_string(get<0>(p)) + ", " + to_string(get<1>(p)) + ", " + to_string(get<2>(p)) + ", " + to_string(get<3>(p)) + ")";
}

void debug_out() { cerr << endl; }

template <typename Head, typename... Tail>
void debug_out(Head H, Tail... T) {
  cerr << " " << to_string(H);
  debug_out(T...);
}

#ifdef LOCAL
#define debug(...) cerr << "[" << #__VA_ARGS__ << "]:", debug_out(__VA_ARGS__)
#else
#define debug(...) 42
#endif

int main() {
  ios::sync_with_stdio(false);
  cin.tie(0);
  cout << fixed << setprecision(17);
  int t, nmax, m, r;
  cin >> t >> nmax >> m >> r;
  for (int qq = 1; qq <= t; qq++) {
    const int MAX = 4 * m;
    int qs = 0;
    auto Query = [&](int x, int y) {
      ++qs;
      cout << x << " " << y << endl;
      int foo;
      cin >> foo;
//      debug(x, y, foo);
      return foo;
    };
    auto QueryPM = [&](int xpy, int xmy) {
//      debug(xpy, xmy);
      assert((xpy + xmy) % 2 == 0);
      int x = (xpy + xmy) / 2;
      int y = (xpy - xmy) / 2;
      return 2 * Query(x, y);
    };
    int n = Query(0, MAX) - Query(0, MAX - 1);
    auto AskXpy = [&](int xpy) {
      int xmy = (xpy % 2 != 0 ? MAX - 1 : MAX);
      int p0 = QueryPM(xpy, xmy) + (xmy == MAX - 1 ? n : 0);
      ++xpy;
      xmy = (xpy % 2 != 0 ? MAX - 1 : MAX);
      int p1 = QueryPM(xpy, xmy) + (xmy == MAX - 1 ? n : 0);
//      debug("xpy", xpy - 1, p1 - p0);
      return p1 - p0;
    };
    auto AskXmy = [&](int xmy) {
      int xpy = (xmy % 2 != 0 ? MAX - 1 : MAX);
      int p0 = QueryPM(xpy, xmy) + (xpy == MAX - 1 ? n : 0);
      ++xmy;
      xpy = (xmy % 2 != 0 ? MAX - 1 : MAX);
      int p1 = QueryPM(xpy, xmy) + (xpy == MAX - 1 ? n : 0);
//      debug("xmy", xmy - 1, p1 - p0);
      return p1 - p0;
    };
    vector<int> xpy;
    vector<int> xmy;
    for (int rot = 0; rot < 2; rot++) {
      for (int i = 0; i < n; i++) {
        int low = -MAX;
        int high = MAX;
        while (low < high) {
          int mid = low + (high - low) / 2;
          int v = (rot == 0 ? AskXpy(mid) : AskXmy(mid));
          if (v <= -n + 2 * i) {
            low = mid + 1;
          } else {
            high = mid;
          }
        }
        xpy.push_back(low);
      }
      swap(xpy, xmy);
    }
    debug(qs, n, xpy, xmy);
    cout << "READY" << endl;
    while (true) {
      string foo;
      cin >> foo;
      if (foo == "ERROR") {
        cerr << "NO SAD" << '\n';
        return 0;
      }
      if (foo == "DONE") {
        break;
      }
      stringstream ss;
      ss << foo;
      int x, y;
      ss >> x;
      cin >> y;
      int ans = 0;
      for (int i = 0; i < n; i++) {
        ans += abs(xpy[i] - (x + y)) + abs(xmy[i] - (x - y));
      }
      ans /= 2;
      cout << ans << endl;
//      debug(x, y, ans);
    }
  }
  return 0;
}
