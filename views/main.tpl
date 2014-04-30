<!DOCTYPE HTML>
<html manifest="/static/bus.appcache">
<head>
    <title>WTHTU1</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0">
    <meta name="mobile-web-app-capable" content="yes">
    <link rel="icon" sizes="120x120" href="apple-touch-icon.png">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.0/jquery.min.js"></script>
    <script src="/static/geoPosition.js" type="text/javascript" charset="utf-8"></script>
    <script src="/static/modernizr.js" type="text/javascript"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/moment.js/2.5.1/moment-with-langs.js"></script>

    <link href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css" rel="stylesheet">
    <link href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css" rel="stylesheet">
    <style>
    html {
        height: 100%;
    }
    body {
        position: relative;
        padding: 5px;
        max-width: 520px;
        min-height: 100%;
        margin: auto;
    }
    @media (min-width: 520px) {
        body {
            box-shadow: 0 0 20px 1px #905050;
            max-width: 510px;
        }
    }
    body:after {
        content: '';
        z-index: -99;
        display: block;
        position: absolute;
        top: 0px;
        bottom: 0px;
        right: 0px;
        left: 0px;
        opacity: 0.05;
        background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAMAAABHPGVmAAAABGdBTUEAALGPC/xhBQAAAaRQTFRFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMalYaAAAAIx0Uk5TlhaTG6WwoBqyCx6sopscnacgq5cfmR2UkZwhlY4li5IjIiYpjYmQJ4iPJIyHhooog4WBfoSCKyx9gCotf3wuMjEwezN6L3l4NnI1dXd0djc4NHNwOXFvO2o8bjptPWw+aD9mQGtEZWlnQUJDRmNiZEVfYWBLXVxIV0lHTk9KXlJWWFlVVFtNTFpTUVCkyaWwAAAfsklEQVQYGQXBg6JsWYIg0Bh7WlVdVjrz5bN17Ygbto5t2977p3utXhseb5cOkcQlMSvlwcK1KN+kXuZFtaw8UKWGHiFOjR+F43DFHF/nyis8PMwvzc7QdS2qjnykhpWRQjtpLDpQTFUQhrP972J3uIwc3/WaHJF73IT3EHONyQqnTVQIxOGvt7JaF3K5XOM7dyDI1VQv1c0xv3T0lzAQ86iJX3cdkg41x1QCweVIKUGI1bm1XhO1cR+L/oaFys6joNLUSBbURm9bwK9yySmu+6MqCJ24VqSu5NofdmOlOGCp1ci5Ob8EObh89le18MLgAWbH/9ZUCR47kyJmcIUArlxGN2Ugzj/bN6fR9qJeC61niRtk516BTEF7QdOmB60uSSfTQ0TwrYLTiq/CFPBE+2AKf2eiGYkrWyQy44z/1CRs35oHxM4U8tBPNVTAGu4X0dq/5tcZs2TlDO7VVRolsSLyzO9t/aNh2FVvlJJQfLpVr0/qY6o37q0Yo3PxdGKWsibL6V8HxMcYGUev9C5qlrp/cDR1Llr8F8r4oToXReV3Rt8KA32bZwZ/4+38bTq5nqTPOmBjNJ8QK8KWQK8uxdyoNFxrle3Snen1ioqasN3qh+JNVdbGiid0Sbl2/TKfJQ+/cQuOMKw4mtKRN9TBhR1RtF67xTGJGQ8DnuKCq9mhpJgLJWqg9VfSb49kr3W0+DWjGaSSw0vQaapjdCyJoHEQykmbfVGDR90u41jAHpbuNfywT+mt6XpgJFeH4i4U0xRxm6Zu/rHSQv/+9+sG4rSnLJ2zrm75c33ohrzas+eJeBA8D2DBSWPsVGOIq5AsfEzUuNWD52wCbXh2XQyZENdvxrWzzCQk04N7slLfLyj+QZfCsixMS05gcNQwxfJZlkBiPZgC7zhVCjMOtV4weO994s/mVikag3ZnelFcdKVUb2kWMoJ1075OTiv4Wq/wlvvAnMFCN6Ic7MIujcr8b/NDQpaGbX78QR/GUFaTeQIK3OGkm9yxClW8FZvGsXs1Tpcz5WtNSdlDZbV6nglu6YZIfXoucMX99Me+/mYqMBEm4X2YhzRrhMbdL2i7YhttHXwOqWSb55ITmIXscoZzj76Kfa8rrZ0Ay/vhUKErGPfKlBRSyJfcWIidwlfoKnAevyxpUGpikcWZqnz6nDvZIxjGULjGmV+E5QscXHwX4I6MYHYsbEJgxPY6I3Y865Wwfl00a6TQHNPNF2d3k1Ztql4EciNK8/SVIf1+7sxkj5RM23h3nipnfF4U3X62c7VIVQk/twKoDTVwWB+nvlfLCa1bj3J+V3gn6SRqj4EqWOtwjYebhAph8NjHX+Db9mq75Hofkv9fsnrmLc+Cxthn1njneZNPdgfO4hnRGppVsqT/tAn2le397e3fN9E9ovzlL9e5DhdsFPACnKb5gYEZ7zDbrH5EufdFxxs/yxqX+DlXmmMq1HrLKs/z5H/pKj3NLfzhuHCCqg8liB0+vNGn7Sf+tChHoxPOP4cu/362qAtC0kNra8dVyzLP4Mgpf/Y3yAOeb5IyqSMRCXy3+mN2v9Flta4Yn1vBXimEZV/V1I3fRlU8Ed0q0/LQaNn2DOJlB45M5X0aajILyO0k9FJZA2o5ie+V1VwDGdgFebF1vrlT4ry4zQcedHIKBXkeVhsvkxsT8jW97S073GTf22Wm2yBN2TRDVaEldhl15MfHpDOllhIavGPJ+OB5Yje71SlEkGVz/6VEBT+fV9lFh9Od2xxK+a5ry0lU3yjQtcRPiCDSF0smi6c9ZDqbZso6afHA8L3Apl0LJJ7whAq3tY6+ZwkxYArATbCsYfe8U+9KNLtlW98Mbacuu7NR6NhOFzOcQKsA55FD15JuR7xsCCmuI7IO7qlDjxlLRmy02bpLxfoBncftvmGHUu6SYDOK+srqYwklx5dIjqUroTweFRrmQZZGiE5Z2eK2iXy/rD8d/+l5kcylD0Yht2mrdNmqDdgKURofrZWefrnJsVQsWnL48VGOY+AhZTf3qJpc6qhxYWyCNHrLCMnqPBgMulqj5CjaGH4/VajHzFIOK18eaVcu0XC/Cp148YVasVmi4zO9rTMjKhSAZmVvZ3l7bBVVvuQI0rP6XTudT24ZBVosD5PrR8nFMVEKPIJ/3K0qvq3TlG7ZFqkfWccRrGr7t5nGZleYH69t+yLaBKwEj7LtTHZRJkiDN9Kdt0J6BlOZeZh71maSHj4FikgDqcRmsUOsy3ZJhqFehZjNYgrd8utMC3KjYCOTICBQ7MQUILu3aDdxeVFOCNpVUcIX76jEKN9nSWYQ2PNTN3vdC8Qydo/dEWRi6OqW1ZxTNcYrgpeb09MHTZ3njxofDbBQtb6SDnL99QtwslhXy8jqLD8STMoTsbYdTxWwqSXJVmTAp0rZComyl7i6QY6a0iOaVIeBh0Zga4TzYmHN4hYY3Yw2jrNMdLya+rhdUHXkyJnXVfW+qQqbKCq7P8jbs82yX+OrVvKc31RBNPv6WNUiq32h13InyQrUcnlty4rTA3Z6N2nkK6NR+E91Q9tCtg19amUtZFPlF+GzJHj3Ew5TnswP6sFQNo0NK9aPNB1nBpGGRALr1PiN10oUIWfvVgXc1Mgd9ehTEh2MqiwtF1rvq9WMhZAeGx9okMJrWfPEkGkbpAuM6zRXEjcr/DY111+hvsdjXEawhkkcy6n0/z3urraN3gBE1+q2epXs+WTbTVMz44yqw/YZKBq8C2uT74W6H5MlaNZN6ibfZ8W+UCpSoaVl51TVo414nslTf5d3RC23QXov+keW33UzjztU0XFwjWAPrjZOQ1JrePpttq2T2AA89Yh+sVGtqmvPzoOm9+Adb2M1qAP0WHIcSPwkVkM+/pIqwZcWoI69l0UOo8LB2g7t9Tv3Vi3fMNdkZOWthWeVAe17/l9qUvWn60ZQm62fZtZLuVx+hCVRthL+Muadnt9VW91Zog+XeQXDQvNayj+JWgMDO1FMA104HNr7p4YZTs65g+PmYTMPSOMgWw44DVJF2qYv5WXfMCjj3WDXPSTC4rFsuyYfT3Y7Sl2YZaNoveCawhtnnR9MrfXS7GgTxLHrQvfndBk8GyTdKDDRZcYQiv1iL0nQ1tXtbUFxQdDySZRaEXYN+BtDeFt48raTnC6v7lrJqqyqTCuptqGjxv1el2eOOi/XUl6HVeXfyDZfJYVzWUbBIgpC6g1gaxgSIwqLpsJoYfnCGOyVg+ElTZfY98e7Tqq+P/DVpOqcZcIpbR5vfDLd3d5slkyodpDL7nuWrYcvdCOVeeXLg8n73rhuW+NaKOS4UjXHaaiSoW9e2RcL9fMnGvJck56aF3WAWOs8XWFVh3VQKBbG9PisEjmoWyy+ydXEtkmvwFu1nSFzuicrZbJT/1HCg5w3+MwWFFwyjbH26I0Tc6NJ20OXqEZKkeWjb2ceG7s0HTZ8Z0mLpEZhM9tZV5kEsM1macd4p47U9p1ppbLDpX57NPLlo5D0Bls7cNTPNpOgaxuD3cd/M0Mh0qrBFyPyqZd9o4FpHjQZpzhq0NXN3MtayO1duT3th/CC3ZY5cXnH7JWsKY15pFX4i8DeLuJ7PeJ3VhXtvKnS88Lvihto5BF0I2Dw2QF05HazFyxddvOH95draC9Ykfxr7uYyLKO62Yq//rYbCFYJjwJ3F7GHQiuOjAtJjbvk9ZQ1oiOKQCplBUtFjgodM07PqXd2/i6uujasmXTUNkE2NoESofFpdQxYC1Cla/hR0KjrrPqldoN8RJnjYvcQ3nmFATeVQ8c3L10K3u9RoVb2RbBCuIpLOe4Kb/xFdsSbtidaxfTO1O/L3Sqgp1HSiTHIVpKZZUX6hvnMXVSBV7hamutlu/VMikQ//HUi9+FWkpfJ8p6uxmJV1Cr/cJ5btknmghJbOTG35fUVXlgpzeyEpleuvU4/3iED30sCQ94PfrhPHSflunakZn2HKhh6HizLefn3ksOyCze6BfSwav6BgHi7AQtekhN2VGL+b09tw8jI+oqMcNDZTTxdPSd/qOafWHjS+9rmka+VpmC1rKOyCZwI9R/exB3NpeX/2XdjwY2ZQ7NuvrhXthcFxmfKlB+d6PiFVTcLfCmFo/jYDgKnDvYGaCYl49g1vCOHEPslDZJ4S30oux6cYQgox+mbtaaQsK2SomOSjYu0cGl2d1hQDmvNMy35ofp5SAQlS1Jd3XjWY+S/TKg2dD652JYjItaMg3m35fMdsSu7u01d123Z/kmxGTJlesmqCFxXn6n8bpcFEsE8EhwV2Yf7yjRqjC3moDUzr7yJVjnkE/vLgjJsKTPh1rltI75F72/xirBylLxyJS573DJZ6ThJQSuTokUK33+ItnXPCkoBVaJb3+FDw8OurIrjm5qbXq21n3zfRP3IOJJ3asbzU9/FVElp2KRUY4mCA5894qXzDj4qmXPgknUbcQcHzZmbom2ybBmqNZfav7Yw7RWGjFoRy4V1EYK2pXmE1pKUpokwPVCspoACXvIHRbtHNe2mbrCFvIOB437CUsaxk/ejf/2/mN9WtqfGfEWWgzQimpaDGsZXQl03cXTg6rL3zIy8K7FQaMOg0BjcA1H039QE5dJSLFV27t0XaDn9YX9QixC4puw9PEUTtpMf28y6DA3ol/xVQborN+2YnKxgg+Pawk+n/7ZOG7SCkyba5D0n5/Jnnk/HkV2wRWwfwYt3YTuxkn1pzvJMBGxM04w/3taOPYu9ff2DJZ7fBZXuHoO8DUCXJjtdeuDW8kqoxduypFa7MXAm1yPiUkrD1WB4HPaeJ7kp1Y5naGEgOKioLDM/IA19kxzSPPWkue8f9MYb8zfKzFKrKHSMhcQGAoQFMUyk9WvyYG6sBtzvw4EUnmPr2ze3bDztQONFUg0lO1LL3g80L0KtpPP4nK+xIo7q4NMozilxiwQGY1zc5T50ilRjMju+A1/r7N0wofxC2H1uMD11+L4hZyeP5/9u6nIjX20amyz05d2B2ueHcW757vJ3xHlv/D4z0AW4w99+VSop2VnZUtFAURmUMn0r4ofoHg+3bKoaKQlOK7rBfRavPwf17Gem8/ysQynXTvuQ2JdobPfnokPR/l1z/2Wf5PdiIMRJoMDeJfKNwMiU6JoKdHGzs9Qm1U34BbEx5GwUuXvmj5/CWu4gPB0xFyko4BhGVFtbfF12WKx+Bv/9mPhc48MA5Ll6jE72OVON6vFlxoXr268rtmB6MtprC39GGm6UdYcMCK6P4j/9mBKuY+60Yrs/0W/dztduFSdN932r3ej6dqG+uao23pd4kbIEGjsQfjPzn39k/VI2D/cL46Gv49v/mb8CuwwKftmT7rIQrXhXDmusMzvYlHGqz1wDg3/+aP0r5/kAWAvXPm4O0TJ4FcLZYkXYtrkOHXFDxSklG01Mj+rV0nqdQs7rAptbGcUg3Vd32tfQfp0Bmu9V7Gs8aUUxT8FwUeTV/kPu/dLJVVOzlO+Rqc18lknhD4NFHjasnIOpVobONhqTVRHV6p4efQDB9jYBlXZ9XBxfaYStOVhYFKoZFoeJ5yU8/rRXSQEGbQYWwgTGKvy4v072XqWo2ryFSudx8Of3J4sBmo8gP3fDhoClaNnATI9erIzx6h0H0gbbBxOc1fQs2DpwmPgF0RTxW4WKC5KzpVLrSedYV6rQvmqYWXIdMhH0z/LM9GOTAi0wvbKJLQJ7p4b3gUuzh3dpwG0s2GKH89Rso4NXRMmkfMRZbuRQQK0gDAt9G6TfZ+3Bp0lylA3Vspcw8syxSV+3qwSh6RUNbjxNkbiv/wyU1Y/JC/aPOv/4OL8gjarztqbD3dNTO0E5GUuCGiRSbl810vV1qt2I/FIUjxn2UTqdp0RNw1YH4mGeSGUvva6ZLsuiKm/2m4Of2nkHUSjM89JYXpEAOM/XElkoJIZFWHPVCfwTJPIgiremFnfDDp+YXfd4EO+PpbNZPhnV07oypat/Iiu7L9uauJoksdSrwq7RynZ9VhjA8qvaOR+X0n5d/+XsfNyyxy/7/xxfIlXjiPxV0t1IFLzcK12n4iu21d+JGX0kR+heWRNCVY2hQ1ZyYR4OyNmpXXzatE1zb4gF0fvVfoNVF9Z3lPOPT5KcVEFhbLTs5KEdoORurGYcYp+9O0Sv4peGU6MQT3lGk38+LDqyKeLSfD/5x2b/LxvWLnbQMk0sLHkGgtdh5we1knMAr1tJ7Xmry7uVyvWfLHA9hZ0WTwSf3aINPZp7TrN8y5tMUmxNxhRCPHDfJmI+H4fJDtRwWKAtKZNGE3pyEjNZ61NmmcqWhQtYsmKZutGyrXAJQ7uXFrv8A8Na47oObg0/216aUz0AwZ3i5vnj9nOOfTuXedNP9FVUrpsH82+2mIq/GiFU4jH4qaFxyTaVTACM2fongb/ErQE1tyNvtKtDO9U+h4nZw0JOrTdysbvDiLnHacLBrC+FV3mYvf1nGNYqBDjJJOaZZdWwZZUX2jVWKp05ttKzRs6Q/wJpsitdOTGsGrdvSQ3e1cqt081eSdeVjVLN4wUV9KQqEbISaTopru4VW8qlRhPPp/R0qtGqPsDl/gYkYodqgicd1Y2IG/jXx1hyvZuSX2htu1KtZkDe1XVDgQjuRPebUB/IqJUWTXcq8KHvAKtn+G3DtgilAZfNJl+tHDE1uXSeTPmohUluVGFf5FWnTty8+GnrRi7X5S7qLgrow2x+ZN8WMr2GlJh5XrKQbtYomRw/Y+a9+fGWd8QkeFr4jz1C3dsO0mqO7lnZgo04WGVpcXY3HPApZXmfrC8qt8iT5g128NLAjfXQgMKvbcMbfTQax0Q0WtUV75+Wvu5ELodhF2+7SyjyoRjFj2gfJCmm9KokrA4J08dqVLeEUdiVIzEczC8tRDzbe27Wr67tB0zRuwokD6n+lo0vjhpo9nYFuKX5QuILNjFor7zZ5lGHzhp42l/Y3b+7UDSjZBuUTZpJPcxS8qs1P1eZo0ZMAa8tj/IXvBPkxzpZa7Lg/oN5NFkt5j2zwaIms84KiohaPnKE49NWzLTTvXi3szrbiY3EPHn4c6ciJsqnljA4xldB39K9sBcFzyBC5BKIVxFE6/rRaWrWi4ykIjZuEajL68gw85TWyFZ9ilbvzuNCJ5QaIZ6nCfstuZ8d97umloSvnJFffD8zk1mq3afkh4GkjzwYfE3BEuvR3oUmX1S4HyStriBxrobRijsIJvMBeJau9P1a3YWaVQI0hg6o10CTO+TRl28syU/dkYd81f7chuBI3aJNSpTfyaNTUu7mqwVMim5yJ4B91os3hndehiP2C1HMwJufLt+a3ut8CoUZ9W350oljULvbX1SyYPg2FSDHsF5+ld8buR1ceDmHLfRdZBgdQLzXE/E+iZsTK5GCT1xXiIpINMXmp5jvpTdoOcxVrzCizDkX9aJTlgAhHXEoU0h5oTedbdEWb3nVh9IeP/0AC616ro5MZjDBPgNmWaM//qe0Fmv0kloLPk28i3+7XO36Yp1kGdPm+denVt7D6RHxBmlUU36IabbxluBRFktte0s7lvWV2pk3Z2GYelWbIsGfvL9zhEM0zt7lM9lcyEb4Y5zqUdRtPrdboKeub9KhECkje3rrnXN1wVCFdi71VnuwqaNcuLEsR5cwsYtosVHauaXUSaCYzr7grb9p4cv3wXP4Ak/q/Z8v/dQlrpXiO1oNJ9e8zrQfcDIXM81pXQdHMkPSBZCpnSq1yb1+ZeylXsPw/cPD6xvHWsNgCXERB0rafOt6bt7t7IHU1g5Lf5fk8QXNrXio6/9vGq9oHxQeEF2qXVbSt10EPKi82YYRY9LXYw2QqV+oyUI6dSFUKZj1DnbzRXG3hkSYHPQjKaOorUsdBw8tW+XMbg7uG8zxd3cW4NQsF3Ug7uNGL5jc+gN6HpqWeRy6WSdsVnt65uWAiwNlWDL7JPgZjcPkhf+r4B57qpmc3gnOzozM5k/TVTwL2tIS418X5eUmciP66sabjF6EPJp+b4kejrZVkp+0cYVIhE96dcJX0GNdTZbtJI8goUVh67KZ39WB1lVZBD9uHL/Xucfio79U7DDi5BPvF0SK40gvEG4+d4vB82CnWk08ccuYr6V2ls8RQ4Ac7hzfFSpa5daMZG8let59pIBSPNHuRkyp2sTZewClY9f9jym9AU/QXpW4dZqU2e1cR8LwEYndfWM2hV5P1tlcbn8+mQRFUpDZ96CV/6hK9J90Z6ElMzdfEnzV5LUTWEXWrUsAiOumitThkuAxC+77LOlkhkJpM9/rcRJi7GMOCeOBU4cdBp4FuSxbKZ6DzNaz+YPanyUuY8yDsu0sNoh16K44T0j7dHZxCysOds1J8M3qwNJ6mB0AJRBz5lUgji8b5/NBEym7aHpw2prPunQRckfDRvSY8VerSzZllUEXrA4BUk6DTG85VVAJvK22afONWEBlMFtBjHsO1DHFDYb+291tslhzU1IQxbasB8vIAI9MzCAX9Wo5vOipHaHWRtcQR/lAWsoafPINiFNEIhyTG5toHS3i0rY1FC9P61VnR9bV0G3dbplbV65cxSwC+bZtkyA3y5dv6PxtuymlhAlsd6vdcTVsi9TrVXI28pG9nZwsQXcs/WIa750ilhUxMkNm2XXs2Y8O2v+o51qiXQ8Vv+zjD3XmZfrdRs4kwuVXSCXTbver95vmOschGSrUhBnvAB/VuF6Rxa7ptXi5OBx00hflKonHi5RaPdDpJSzF7StHdcpnrDbtt9J4lww5VeECPhLsMBGq9+m95ASpFaMLNkTcxxQwqfq8VYLjeg3jwnY16YZORWRfN1bPK7SnsEmGESNQCrr7yJDEko7el9cgSMIgTUqhxFt3o95UWZiaWg1btxpFKEvqLQBoiIKcFnC3zczCbIagrlzX7fLURO2v6X4GA587rPDetvOLyCqHc6Yww2YcbG8X1aRYVCfVMdzTzM2aRqSZtnI4Lv6zdUKusbp9gf7h19TUZD/AC6JpJCaqSwF0H2roiTO0P/mWtiH/4L/rbj58rYnl9Gsv9H1vXia6XCd7sY0jzjtrKBCrH2aRSnDDsGMMfYcY7UN78avbBbqwS1IYgbij4IPq450Ud02hBFAeYVIFf/Q1Bc72B2LXn16OdipfhaXc9mItqdhEK0WxXZOVXzK+wYRPSMb1jLU10wVa10gPbIc6Owau5zKkr1e2GzZdB/+2VjJWV0PTYMIR7eL7YXuu1CEWsrFsDECmWYZbCshJ1JP0jmqobSRAcgDMHfJkOzZD95dq7ZQpS30XAImJ6qzslN1f/o7aHOrsWCaBSPjBnndHrK7f8hIfdHVk47rpfezvqrfOIyQ4HoXG0/tMrcVcjHsZOvHXnZ/V5XPQgDgMHoS0MKBbeC+MyVguwzkjy1XeDkT23uwOoTSrqpdKs2Nf/whUpvNKXrZnt5v3//UA6dPJCgtxOyrtD50ZfGfOoaEcpxTWO0lvX0zEzV2+n1i+GESda1iAZRuLgKCFVfckTh+9xi3T5g46wshk+iKR1Tre9pOFuQ8w72Q8qdj4L9ul5ePuljWHFw8qz8YM80cOorQlBLLWg8UBcMnP7Ndq9/Ug4kYWr2JzlO7atGkwbyGhSZU4QdMxydoa00Ze1MaVE2JadrtSJwGsfbrl7F0Y2YT3GdwMi3anTMMtD10ldys0b8Oovu1Fqi+Qj2yAOJaPRZrVepMVCBGVimkM8x6KArsu/Pd+ReLvS9df2OoJPffNwNaUB7Mfq7Etv9h3eZWiPjlAOSpaOBzn5KbuRZ3ZzqLQE42wZz6S3dr53KAOZtD5Cd/eLvpktUmePrphRxe2WuUL+62ySxKiWNQxAJHT5xXOU0eVDl2fHyoj0dV1nQn0l1EEKDH9cOs8z2bCA4w/n7EcleleT7aJTcV6jCmO8CO57r7fU/NJ6c8NM9WwMI8zstNVEuThtf0UcFVHiLKslx6uBcnkOHy2zLC4i+XyXOA/ez91G/M+W6f01br6VRU+/qWTIr1b7HsuXNnq2sBkpmnsA6EjYtGV6zrI6yxKyk3Ddqpbu447FTtDN0zrTE3B8L54PhXyB9aqTr3C52OtchdowMax3Uo2Q5370vt0vtCzojBTRwM9/eO0UGQRO5YHq1Nb2s9BlEHNRQ/oRtPKu/CiYBecIle1FAvZ8NUYkDy28ZHoEi/R9ZOGgvmju1FqX/M5P49uDWoPfJP6Js3uDX06qdeqZPaqzYPv73ztSe1eScFg9kCE4cMd+4WoYgTDQqPgExPNYqmSPLiKPn+LlnDT2V16zFKVDCBpzx+htzmWVhSXNTDJB9UHcmbYVqE8UFXwObMJvifnjDL9WOGaWeRsW4UEh0hHNvbvJm3/IKzF1WmWwsJMxer4kvnzWxBGmzkfzjIb/NDxCbcLuC6bujbJ41O0dVqhlY73zQoEjqHnsEQekqKzejcmAHEiEkHz7zsgatb0kH3pmoPgEk0St2AmKYip3MFk9V5Nm7q47sj8T8mIOTjTRt2LLBDp9UVFdI7Pa+p1ozeChH3WIQcar05/j8d2FhZqz1Q3kYMGQiHbLV2i1HEfw6qprmjfyGk+MI9Z3sjM2H+lg2a+q6V79RBx4qZeQi8xXOWnMsfu2tqxyqUuecL3+5ijd0F3Ff+14xx3RJSreZz2JOvYVjeyWLyCdnAp5AKRPLu/FWi9PgLhsQ9ja3bphs0nCimW6GkXEz6XFfbeFMTZxczcBwg4aQz7qDTLsv1s0VzZV+089PVDpMBF7LutaT32frEKnZSzEG40dq62Huqh8NyDBIXJv8tOa31DuRLhk7Byn+j9MByMC7Jd5EtzvXCksA0etm6TbcaQX2RzojFLZpiFebI8qMVyxaddkrvkzv4Pt7iFz9PXmP4AAAAASUVORK5CYII=)
    }
    body h1:first-child {
        margin-top: 0px;
    }
    .btn:focus {
        outline: none;
    }
    .btn:active:focus {
        outline: none;
    }
    .btn:hover {
        background-color: white;
    }
    .btn-default:focus {
        background-color: white;
    }
    .update > *{
        display: inline-block;
        vertical-align: top;
    }
    #loc, #nearest {
        white-space: nowrap;
    }
    .grey {
        color: #b9b9b9;
    }
    #updateError {
        display: none;
    }
    #offlineError {
        display: none;
    }
    #accuracyWarning {
        display: none;
    }
    #map-canvas {
        height: 200px;
        width: 100%;
        display: none;
    }
    #bus {
        font-weight: bold;
    }
    </style>
</head>
<body>
<h1>Where the hell's the <span class="routeNumber">U1</span>?</h1>

<div class="alert alert-danger" id="offlineError">
    <strong>Offline!</strong>
    There doesn't appear to be an internet connection so I can't get the latest
    bus data :(
</div>

<p>Your location is: <span id="loc">...</span></p>

<p>Your nearest <span class="routeNumber">U1</span> bus stop is: <span id="nearest">...</span></p>

<p>and the next bus is <span id="bus">...</span><small class="grey" id="busTime"></small></p>

<p>
    <div id="map-canvas"></div>
</p>

<div class="alert alert-danger" id="updateError">
<strong>Oh snap!</strong> We couldn't get the latest bus data :(
<pre id="errorMessage"></pre>
</div>

<div class="alert alert-warning" id="accuracyWarning">
    <strong>Rubbish Location Data!</strong>
    The accuracy of the location data your device gave me is pretty crap,
    the bus stop picked is really just a guess I'm afraid :(
</div>

<p class="update">
    <button type="button" class="btn btn-default" id="updateButton" disabled>
        <i class="fa fa-compass fa-spin"></i>
        Getting Location
    </button>
    <small class="grey">Last Update:<br/><span id="lastUpdate">Never<span></small>
</p>

<script type="text/javascript">
    var locElmt = document.getElementById("loc");
    var nearestElmt = document.getElementById("nearest");
    var busElmt = document.getElementById("bus");
    var updateButton = $('#updateButton');
    var lastUpdate = null;
    var nextBus = null;
    var updateTimeout = null;
    var updateInterval = 20000; // Update the timers every 20 seconds
    var watch = null;
    var watchTimeout = null;
    var ipRequest = null;
    var userMarker = null;
    var busMarker = null;
    var accuracyCircle = null;
    var map = null;
    var userCoords = null;
    var stopCoords = null;

    function setup() {
        $('#updateButton').click(function(event){
            if (navigator.onLine) {
                this.disabled = true;
                $(this).find('.fa-compass').addClass('fa-spin')
                $(this).contents().last()[0].textContent=' Getting Location';
                if(navigator.geolocation){
                    navigator.geolocation.clearWatch(watch);
                    watch = navigator.geolocation.watchPosition(success_callback,error_callback,{enableHighAccuracy:true});
                    watchTimeout = window.setTimeout(cancelGeoWatch, 15000);
                    ipRequest = $.getJSON("http://ip-dir.herokuapp.com") // Use the ip db, it should return faster and with a better result
                        .done(function(data) {
                            if (data.location) {
                                success_callback({coords:data.location});
                            }
                        });
                } else {
                    geoPosition.getCurrentPosition(
                                                success_callback,
                                                error_callback,
                                                {enableHighAccuracy:true}
                    );
                }
            }
        });

        $(window).on('online offline', function(event){
            if (event.type==="offline"){
                $('#offlineError').show();
                $('#updateButton').prop('disabled', true);
            }else{
                $('#offlineError').hide();
                $('#updateButton').prop('disabled', false);
            }
        });

        if (!navigator.onLine) {
            $(window).trigger('offline');
        }


        if(navigator.geolocation){
            $('#updateButton').click();
        }else if(geoPosition.init()){  // Geolocation Initialisation
            $('#updateButton').click();
        } else {
                // You cannot use Geolocation in this device
            locElmt.innerHTML = "Damn, can't get your location. Sorry :(";
        }

        if (Modernizr.localstorage) {
            nextBus = moment(localStorage.getItem("nextBus"));
            lastUpdate = moment(localStorage.getItem("lastUpate"));
            busStop = localStorage.getItem("busStop");
            if (busStop && nextBus.isAfter()) {
                nearestElmt.innerHTML = busStop;
            }
        }

        updateTimers(); // Get the ball rolling
    }

    function cancelGeoWatch() {
        navigator.geolocation.clearWatch(watch);
    }

    // p : geolocation object
    function success_callback(p) {
        // p.latitude : latitude value
        // p.longitude : longitude value

        coords = p.coords;
        if (coords.name) {
            locElmt.innerHTML = coords.name +
                "<br/>Location Accuracy is " +
                Math.round(coords.accuracy) + "m";
        } else {
            locElmt.innerHTML = Math.round(coords.latitude*10000)/10000 + ", " +
                Math.round(coords.longitude*10000)/10000 +
                "<br/>Location Accuracy is " +
                Math.round(coords.accuracy) + "m";
        }


        if (coords.accuracy >= 50) {
            $('#accuracyWarning').show();
        }else{
            $('#accuracyWarning').hide();
            if(watch!=null){
                navigator.geolocation.clearWatch(watch);
                watch = null;
                window.clearTimeout(watchTimeout);
            }
            if(ipRequest!=null){
                ipRequest.abort();
                ipRequest = null;
            }
        }

        userCoords = coords;
        placeUserMarker();

        getBusData(coords);

    }

    function error_callback(p){
        // p.message : error message
        locElmt.innerHTML = "Damn, can't get your location. Sorry :(";
        updateButton.prop('disabled', false);
        updateButton.find('.fa-compass').removeClass('fa-spin');
        updateButton.contents().last()[0].textContent=' Update Bus Info';
    }

    function getBusData(coords) {
        if (!coords) return;
        var update_moment = new moment();

        updateButton.contents().last()[0].textContent=' Getting Bus Info';
        $(updateButton).prop('disabled', true);

        $.getJSON("/nearest", {
            lat: coords.latitude,
            lon: coords.longitude
        })
          .done(function(data){
            $('#updateError').hide();
            lastUpdate = update_moment;
            updateTimers();

            if (Modernizr.localstorage) {
                localStorage.setItem("lastUpdate", lastUpdate);
            }

            nearestElmt.innerHTML = data.stop.name + ", ~" +
                Math.round(data.stop.distance) + "m away";

            if (Modernizr.localstorage) {
                localStorage.setItem("busStop", nearestElmt.innerHTML);
            }

            stopCoords = data.stop.location;
            placeStopMarker();

            if (data.next_bus != null){
                nextBus = moment(data.next_bus.time);
                if (Modernizr.localstorage) {
                    localStorage.setItem("nextBus", nextBus);
                }
                updateTimers();
                $('.routeNumber').text(data.next_bus.route_number);
            }else{
                busElmt.innerHTML = "Sorry, that data is not avaliable at the moment :(";
            }

            updateButton.prop('disabled', false);
            updateButton.find('.fa-compass').removeClass('fa-spin');
            updateButton.contents().last()[0].textContent=' Update Bus Info';
          })
          .fail(function( jqxhr, textStatus, error ) {
            if (navigator.onLine) {
                updateButton.prop('disabled', false);
                updateButton.find('.fa-compass').removeClass('fa-spin');
                updateButton.contents().last()[0].textContent=' Update Bus Info';
                var err = textStatus + ", " + error;
                $('#errorMessage').text(err);
                $('#updateError').show();
            }
          });
    }

    function placeUserMarker() {
        if (map) {
            var coords = userCoords;

            if (userMarker) { userMarker.setMap(null) }

            var googUserLatLon = new google.maps.LatLng(coords.latitude, coords.longitude);

            userMarker = new google.maps.Marker({
                position: googUserLatLon,
                icon: {
                    url: '/static/user-marker.png',
                    anchor: new google.maps.Point(8, 8),
                    scaledSize: new google.maps.Size(16, 16),
                    size: new google.maps.Size(32, 32)
                }
            });

            userMarker.setMap(map);

            if (accuracyCircle) { accuracyCircle.setMap(null) }

            var accuracyCircleOptions = {
                strokeColor: '#5191E7',
                strokeOpacity: 0.8,
                strokeWeight: 1,
                fillColor: '#5191E7',
                fillOpacity: 0.35,
                center: googUserLatLon,
                radius: coords.accuracy
            };

            accuracyCircle = new google.maps.Circle(accuracyCircleOptions);
            accuracyCircle.setMap(map);
        }
    }

    function placeStopMarker() {
        if (map) {

            var coords = stopCoords;

            var googBusLatLon = new google.maps.LatLng(coords.lat, coords.lon);
            var googUserLatLon = new google.maps.LatLng(userCoords.latitude, userCoords.longitude);

            if (busMarker) {busMarker.setMap(null)}

            busMarker = new google.maps.Marker({
                position: googBusLatLon,
                icon: {
                    url: '/static/bus-marker.png',
                    anchor: new google.maps.Point(16, 32),
                    scaledSize: new google.maps.Size(32, 32),
                    size: new google.maps.Size(64, 64)
                }
            });

            busMarker.setMap(map);

            var bounds = new google.maps.LatLngBounds(googBusLatLon);
            bounds = bounds.extend(googUserLatLon);
            map.fitBounds(bounds);
        }
    }

    function updateTimers() {
        if (lastUpdate) {
            $('#lastUpdate').text(lastUpdate.fromNow());
        }

        if (nextBus) {
            if (nextBus.isAfter(moment().subtract('s', 40))) {
                $('#bus').text(nextBus.fromNow());
                $('#busTime').text(nextBus.format(' (HH:mm)'));
                if (moment().add('m', 5).isAfter(nextBus)) {
                    // If bus is in 5 mins turn text red
                    $('#bus').addClass('text-danger');
                } else {
                    $('#bus').removeClass('text-danger');
                }
                if (moment().isAfter(nextBus)) {
                    $('#bus').text('now');
                }
            } else {
                $('#bus').text('...');
                $('#busTime').text('');
                $('#bus').removeClass('text-danger');
                getBusData(userCoords);
                nextBus = null;
            }
        }

        clearTimeout(updateTimeout);
        var timeTillMin = 1100 - moment().milliseconds();
        updateTimeout = window.setTimeout(updateTimers, Math.min(updateInterval, timeTillMin));
    }

    function initializeMap() {
        var mapOptions = {
          center: new google.maps.LatLng(52.287373, -1.548609),
          zoom: 12,
          streetViewControl: false
        };
        map = new google.maps.Map(document.getElementById("map-canvas"),
            mapOptions);

        if (userCoords) {
            placeUserMarker();
        }
        if (stopCoords) {
            placeStopMarker();
        }

        $('#map-canvas').show();
    }

    function loadMapsScript() {
        var script = document.createElement('script');
        script.type = 'text/javascript';
        script.src = '//maps.googleapis.com/maps/api/js?key=AIzaSyB8UbiD-uUDWxHJxR4fXgBbcBzgFFKUDCY&sensor=true&' +
          'callback=initializeMap';
        document.body.appendChild(script);
    }

    var AppCacheTimeout = -1;
    function AppCacheReady() {
        clearTimeout(AppCacheTimeout);
        window.applicationCache.removeEventListener('noupdate',
            arguments.callee, false);
        window.applicationCache.removeEventListener('cached',
            arguments.callee, false);

        $(setup);
        loadMapsScript();

        //Load the external api (dynamic script insertion),
        //  initalize the page, etc....
    }
    if (window.applicationCache && window.applicationCache.status != window.applicationCache.UNCACHED) {
        AppCacheTimeout = setTimeout(AppCacheReady, 2000);

        window.applicationCache.addEventListener('updateready', function () {
            window.applicationCache.swapCache();
            location.reload();
        }, false);
        window.applicationCache.addEventListener('obsolete',function () {
            window.location.reload(true);
        }, false);
        window.applicationCache.addEventListener('noupdate', AppCacheReady,
            false);
        window.applicationCache.addEventListener('cached', AppCacheReady,
            false);
        window.applicationCache.addEventListener('error', function() {
        // provide user feedback - your page is probably broken.
        }, false);
    } else {
        AppCacheReady();
    }
</script>

<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-9039747-5', 'jerix.co.uk');
  ga('send', 'pageview');

</script>

</body>
</html>
<html>
