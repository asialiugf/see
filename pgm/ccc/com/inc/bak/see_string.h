
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#ifndef _SEE_STRING_H_INCLUDED_
#define _SEE_STRING_H_INCLUDED_


#include <see_com_common.h>

typedef struct {
    size_t      len;
    u_char     *data;
} see_str_t;


typedef struct {
    see_str_t   key;
    see_str_t   value;
} see_keyval_t;


#define see_string(str)     { sizeof(str) - 1, (u_char *) str }
#define see_null_string     { 0, NULL }
#define see_str_set(str, text)                                               \
    (str)->len = sizeof(text) - 1; (str)->data = (u_char *) text
#define see_str_null(str)   (str)->len = 0; (str)->data = NULL


#define see_tolower(c)      (u_char) ((c >= 'A' && c <= 'Z') ? (c | 0x20) : c)
#define see_toupper(c)      (u_char) ((c >= 'a' && c <= 'z') ? (c & ~0x20) : c)

void see_strlow(u_char *dst, u_char *src, size_t n);

#define see_strncmp(s1, s2, n)  strncmp((const char *) s1, (const char *) s2, n)


/* msvc and icc7 compile strcmp() to inline loop */
#define see_strcmp(s1, s2)  strcmp((const char *) s1, (const char *) s2)


#define see_strstr(s1, s2)  strstr((const char *) s1, (const char *) s2)
#define see_strlen(s)       strlen((const char *) s)

#define see_strchr(s1, c)   strchr((const char *) s1, (int) c)

static see_inline u_char *
see_strlchr(u_char *p, u_char *last, u_char c)
{
    while (p < last) {

        if (*p == c) {
            return p;
        }

        p++;
    }

    return NULL;
}


/*
 * msvc and icc7 compile memset() to the inline "rep stos"
 * while ZeroMemory() and bzero() are the calls.
 * icc7 may also inline several mov's of a zeroed register for small blocks.
 */
#define see_memzero(buf, n)       (void) memset(buf, 0, n)
#define see_memset(buf, c, n)     (void) memset(buf, c, n)


#if (SEE_MEMCPY_LIMIT)

void *see_memcpy(void *dst, const void *src, size_t n);
#define see_cpymem(dst, src, n)   (((u_char *) see_memcpy(dst, src, n)) + (n))

#else

/*
 * gcc3, msvc, and icc7 compile memcpy() to the inline "rep movs".
 * gcc3 compiles memcpy(d, s, 4) to the inline "mov"es.
 * icc8 compile memcpy(d, s, 4) to the inline "mov"es or XMM moves.
 */
#define see_memcpy(dst, src, n)   (void) memcpy(dst, src, n)
#define see_cpymem(dst, src, n)   (((u_char *) memcpy(dst, src, n)) + (n))

#endif


#if ( __INTEL_COMPILER >= 800 )

/*
 * the simple inline cycle copies the variable length strings up to 16
 * bytes faster than icc8 autodetecting _intel_fast_memcpy()
 */

static see_inline u_char *
see_copy(u_char *dst, u_char *src, size_t len)
{
    if (len < 17) {

        while (len) {
            *dst++ = *src++;
            len--;
        }

        return dst;

    } else {
        return see_cpymem(dst, src, len);
    }
}

#else

#define see_copy                  see_cpymem

#endif


#define see_memmove(dst, src, n)   (void) memmove(dst, src, n)
#define see_movemem(dst, src, n)   (((u_char *) memmove(dst, src, n)) + (n))


/* msvc and icc7 compile memcmp() to the inline loop */
#define see_memcmp(s1, s2, n)  memcmp((const char *) s1, (const char *) s2, n)


u_char *see_cpystrn(u_char *dst, u_char *src, size_t n);
u_char *see_pstrdup(see_pool_t *pool, see_str_t *src);
u_char * see_cdecl see_sprintf(u_char *buf, const char *fmt, ...);
u_char * see_cdecl see_snprintf(u_char *buf, size_t max, const char *fmt, ...);
u_char * see_cdecl see_slprintf(u_char *buf, u_char *last, const char *fmt,
    ...);
u_char *see_vslprintf(u_char *buf, u_char *last, const char *fmt, va_list args);
#define see_vsnprintf(buf, max, fmt, args)                                   \
    see_vslprintf(buf, buf + (max), fmt, args)

see_int_t see_strcasecmp(u_char *s1, u_char *s2);
see_int_t see_strncasecmp(u_char *s1, u_char *s2, size_t n);

u_char *see_strnstr(u_char *s1, char *s2, size_t n);

u_char *see_strstrn(u_char *s1, char *s2, size_t n);
u_char *see_strcasestrn(u_char *s1, char *s2, size_t n);
u_char *see_strlcasestrn(u_char *s1, u_char *last, u_char *s2, size_t n);

see_int_t see_rstrncmp(u_char *s1, u_char *s2, size_t n);
see_int_t see_rstrncasecmp(u_char *s1, u_char *s2, size_t n);
see_int_t see_memn2cmp(u_char *s1, u_char *s2, size_t n1, size_t n2);
see_int_t see_dns_strcmp(u_char *s1, u_char *s2);
see_int_t see_filename_cmp(u_char *s1, u_char *s2, size_t n);

see_int_t see_atoi(u_char *line, size_t n);
see_int_t see_atofp(u_char *line, size_t n, size_t point);
ssize_t see_atosz(u_char *line, size_t n);
off_t see_atoof(u_char *line, size_t n);
time_t see_atotm(u_char *line, size_t n);
see_int_t see_hextoi(u_char *line, size_t n);

u_char *see_hex_dump(u_char *dst, u_char *src, size_t len);


#define see_base64_encoded_length(len)  (((len + 2) / 3) * 4)
#define see_base64_decoded_length(len)  (((len + 3) / 4) * 3)

void see_encode_base64(see_str_t *dst, see_str_t *src);
void see_encode_base64url(see_str_t *dst, see_str_t *src);
see_int_t see_decode_base64(see_str_t *dst, see_str_t *src);
see_int_t see_decode_base64url(see_str_t *dst, see_str_t *src);

uint32_t see_utf8_decode(u_char **p, size_t n);
size_t see_utf8_length(u_char *p, size_t n);
u_char *see_utf8_cpystrn(u_char *dst, u_char *src, size_t n, size_t len);


#define SEE_ESCAPE_URI            0
#define SEE_ESCAPE_ARGS           1
#define SEE_ESCAPE_URI_COMPONENT  2
#define SEE_ESCAPE_HTML           3
#define SEE_ESCAPE_REFRESH        4
#define SEE_ESCAPE_MEMCACHED      5
#define SEE_ESCAPE_MAIL_AUTH      6

#define SEE_UNESCAPE_URI       1
#define SEE_UNESCAPE_REDIRECT  2

uintptr_t see_escape_uri(u_char *dst, u_char *src, size_t size,
    see_uint_t type);
void see_unescape_uri(u_char **dst, u_char **src, size_t size, see_uint_t type);
uintptr_t see_escape_html(u_char *dst, u_char *src, size_t size);
uintptr_t see_escape_json(u_char *dst, u_char *src, size_t size);

void see_sort(void *base, size_t n, size_t size,
    see_int_t (*cmp)(const void *, const void *));
#define see_qsort             qsort


#define see_value_helper(n)   #n
#define see_value(n)          see_value_helper(n)


#endif /* _SEE_STRING_H_INCLUDED_ */
