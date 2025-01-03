package MT::Plugin::JsonComma;
use strict;
use warnings;
use parent qw( MT::Plugin );

sub _hdlr_jsoncomma {
    my ($ctx, $args) = @_;
    
    # 通常のループチェック
    return q{} if $ctx->var('__last__');
    
    # カテゴリー内のループチェック（<mt:SubCategories top="1"> と <mt:TopLevelCategories> 向けの処理）
    my $is_subcategory_last = $ctx->stash('subCatIsLast');
    
    # トップレベルのカテゴリーループの最後の要素かどうかを判定
    # __last__が未定義の場合のみsubCatIsLastを考慮することで、
    # ネストされたループ内での誤動作を防止
    return q{} if ($is_subcategory_last && !defined($ctx->var('__last__')));
    
    # それ以外の場合はカンマを出力
    return ',';
}

1;