#include <iostream>
using namespace std;
#include "vector"

class Solution {
public:
    int maxArea(vector<int>& height) {
        int left = 0;
        int right = height.size() - 1;
        int best = 0;

        while (left < right) {
            int width = right - left;
            int h = min(height[left], height[right]);
            int area = width * h;

            if (area > best) {
                best = area;
            }

            if (height[left] < height[right]) {
                left++;
            } else {
                right--;
            }
        }

        return best;
    }
};