#include <iostream>
using namespace std;

class Solution {
public:
    string longestPalindrome(string s) {
        int start = 0;
        int maxLen = 1;

        for (int i = 0; i < s.size(); i++) {
            // Odd-length palindrome
            int left = i;
            int right = i;

            while (left >= 0 && right < s.size() && s[left] == s[right]) {
                int len = right - left + 1;

                if (len > maxLen) {
                    maxLen = len;
                    start = left;
                }

                left--;
                right++;
            }

            // Even-length palindrome
            left = i;
            right = i + 1;

            while (left >= 0 && right < s.size() && s[left] == s[right]) {
                int len = right - left + 1;

                if (len > maxLen) {
                    maxLen = len;
                    start = left;
                }

                left--;
                right++;
            }
        }
        return s.substr(start, maxLen);
    }
};