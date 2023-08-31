def is_safe(board, row, col):
    n = len(board)
    
    # 检查同一列上是否有其他Super-Queen
    for i in range(row):
        if board[i][col] == 1:
            return False
    
    # 检查左上方对角线上是否有其他Super-Queen
    i, j = row, col
    while i >= 0 and j >= 0:
        if board[i][j] == 1:
            return False
        i -= 1
        j -= 1
    
    # 检查右上方对角线上是否有其他Super-Queen
    i, j = row, col
    while i >= 0 and j < n:
        if board[i][j] == 1:
            return False
        i -= 1
        j += 1
    
    return True


def count_super_queen_placements(n):
    board = [[0] * n for _ in range(n)]
    return count_placements(board, 0, n)


def count_placements(board, row, n):
    if row == n:
        return 1

    count = 0
    for col in range(n):
        if is_safe(board, row, col):
            board[row][col] = 1
            count += count_placements(board, row + 1, n)
            board[row][col] = 0

    return count


# 读取输入
n = int(input())

# 计算结果并输出
result = count_super_queen_placements(n) // n
print(result)